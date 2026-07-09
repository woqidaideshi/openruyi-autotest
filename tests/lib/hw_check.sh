#!/bin/bash
# ============================================================
# hw_check.sh — 硬件环境检查 & 多服务器远程执行公共库
# ============================================================
#
# 用于 local provision 模式下：
#   1. 检查当前环境是否满足测试用例声明的硬件要求
#   2. 在多台服务器上远程执行命令
#
# 依赖：
#   - topology.env（仓库根目录），由 Plan 的 environment-file 加载
#   - sshpass（可选，用于密码认证的远程执行）
#
# 用法：
#   . "$(dirname "$0")/../../lib/hw_check.sh"
#
#   hwVerify           # 综合检查 hardware-require 全部字段
#   hwServerVerify     # 仅检查服务器数量
#   hwCpuCheck         # 仅检查 CPU
#   hwMemCheck         # 仅检查内存
#   hwDiskCheck        # 仅检查磁盘数量
#   hwRunOnServer 1 "hostname"
#   hwGetServerInfo 1 host
# ============================================================

# ── 内部：从 main.fmf 读取字段值 ──────────────────────────
_hwFmfGet() {
    local section="$1"   # 如 "hardware-require"
    local key="$2"       # 如 "server"
    local file="${3:-main.fmf}"

    # 解析 hardware-require 下的 key: value
    # 支持格式：
    #   hardware-require:
    #     server: 2
    #     cpu: ">= 4"
    awk -v sec="$section" -v k="$key" '
        $0 ~ "^"sec":" { in_section=1; next }
        in_section && /^[a-z]/ { if ($1 == k":") { gsub(/"/, "", $2); print $2; exit } }
        in_section && /^[^ ]/ { exit }
    ' "$file"
}

# ── 内部：解析比较运算符 ──────────────────────────────────
# 返回: op（运算符）actual（数值）
_hwParseOp() {
    local raw="$1"
    if [[ "$raw" =~ ^(\>=|\<=|!=|>|<|=) ]]; then
        op="${BASH_REMATCH[1]}"
        actual="${raw#$op}"
        # 去掉多余空格和引号
        actual=$(echo "$actual" | tr -d '"'"'" | xargs)
    else
        op="="
        actual=$(echo "$raw" | tr -d '"'"'" | xargs)
    fi
    echo "$op|$actual"
}

# ── 内部：通用比较函数 ────────────────────────────────────
_hwCompare() {
    local have="$1"      # 实际值
    local need_raw="$2"  # 原始需求字符串（如 ">= 4"）
    local type="${3:-int}" # int 或 str

    local parsed=$(_hwParseOp "$need_raw")
    local op="${parsed%%|*}"
    local val="${parsed##*|}"

    case "$type" in
        int)
            case "$op" in
                "=")  [ "$have" -eq "$val" ] ;;
                "!=") [ "$have" -ne "$val" ] ;;
                ">")  [ "$have" -gt "$val" ] ;;
                ">=") [ "$have" -ge "$val" ] ;;
                "<")  [ "$have" -lt "$val" ] ;;
                "<=") [ "$have" -le "$val" ] ;;
                *)    return 1 ;;
            esac
            ;;
        str)
            case "$op" in
                "=")  [ "$have" = "$val" ] ;;
                "!=") [ "$have" != "$val" ] ;;
                *)    return 1 ;;
            esac
            ;;
    esac
}

# ════════════════════════════════════════════════════════════
# 公共函数
# ════════════════════════════════════════════════════════════

# ── hwGetServerInfo：获取服务器连接信息 ─────────────────────
# 参数: <索引: 1~N> <字段: host|port|user|password>
# 示例: host=$(hwGetServerInfo 1 host)
hwGetServerInfo() {
    local idx="$1"
    local field="$2"
    local var="TEST_SERVER_${idx}_${field^^}"
    echo "${!var}"
}

# ── hwRunOnServer：在指定服务器上执行命令 ──────────────────
# 参数: <索引: 1~N> <命令>
# 返回: 命令的退出码
# 示例: hwRunOnServer 2 "df -h"
hwRunOnServer() {
    local idx="$1"; shift
    local host=$(hwGetServerInfo "$idx" host)
    local port=$(hwGetServerInfo "$idx" port)
    local user=$(hwGetServerInfo "$idx" user)
    local pass=$(hwGetServerInfo "$idx" password)

    port="${port:-22}"
    user="${user:-root}"

    # 如果是本机，直接执行
    if [ "$host" = "localhost" ] || [ "$host" = "127.0.0.1" ] || [ "$host" = "$(hostname -I 2>/dev/null | awk '{print $1}')" ]; then
        rlLogInfo "[local@$idx] $*"
        eval "$@"
        return $?
    fi

    # 远程执行
    rlLogInfo "[$user@$host:$port] $*"
    if [ -n "$pass" ] && command -v sshpass >/dev/null 2>&1; then
        sshpass -p "$pass" ssh -o StrictHostKeyChecking=no \
            -o ConnectTimeout=10 -p "$port" "${user}@${host}" "$@"
    else
        ssh -o StrictHostKeyChecking=no \
            -o ConnectTimeout=10 -p "$port" "${user}@${host}" "$@"
    fi
}

# ── hwServerVerify：检查服务器数量是否满足要求 ──────────────
# 读取 main.fmf 中的 hardware-require.server
# 与 topology.env 中的 TEST_SERVER_COUNT 比较
# 不满足时退出码 0（tmt 视为 skip）
hwServerVerify() {
    local have=${TEST_SERVER_COUNT:-1}
    local need
    need=$(_hwFmfGet "hardware-require" "server" "${1:-main.fmf}")

    [ -z "$need" ] && return 0

    if [ "$have" -lt "$need" ]; then
        echo "SKIP: need $need servers, but TEST_SERVER_COUNT=$have"
        rlLogWarning "环境不满足: 需要 $need 台服务器, 实际只有 $have 台"
        rlLogWarning "请在 topology.env 中配置更多服务器后重试"
        exit 0
    fi
    rlLogInfo "hw: servers OK ($have >= $need)"
    return 0
}

# ── hwCpuCheck：检查 CPU 核心数 ────────────────────────────
hwCpuCheck() {
    local need
    need=$(_hwFmfGet "hardware-require" "cpu" "${1:-main.fmf}")
    [ -z "$need" ] && return 0

    local have=$(nproc)

    if ! _hwCompare "$have" "$need" int; then
        echo "SKIP: need cpu $need, have $have cores"
        rlLogWarning "环境不满足: CPU 需要 $need, 实际 $(nproc) 核"
        exit 0
    fi
    rlLogInfo "hw: CPU OK ($have $need)"
    return 0
}

# ── hwMemCheck：检查内存大小（GB）───────────────────────────
hwMemCheck() {
    local need
    need=$(_hwFmfGet "hardware-require" "memory" "${1:-main.fmf}")
    [ -z "$need" ] && return 0

    # 获取可用内存（GB），用 free 命令
    local have=$(free -g | awk '/^Mem:/{print $7}')
    [ -z "$have" ] && have=$(free -g | awk '/^Mem:/{print $2}')

    # 如果 need 中包含 GiB/GB 单位，提取数字部分
    local need_num=$(echo "$need" | grep -oP '[\d.]+' | head -1)

    if [ -z "$need_num" ]; then
        rlLogWarning "hw: 无法解析内存需求 '$need'，跳过检查"
        return 0
    fi

    if [ "$have" -lt "$need_num" ]; then
        echo "SKIP: need memory $need, have ${have}G"
        rlLogWarning "环境不满足: 内存需要 $need, 实际 ${have}G"
        exit 0
    fi
    rlLogInfo "hw: Memory OK (${have}G >= $need)"
    return 0
}

# ── hwDiskCheck：检查磁盘数量 ───────────────────────────────
hwDiskCheck() {
    local need
    need=$(_hwFmfGet "hardware-require" "disk" "${1:-main.fmf}")
    [ -z "$need" ] && return 0

    local have=$(lsblk -nd 2>/dev/null | wc -l)

    if ! _hwCompare "$have" "$need" int; then
        echo "SKIP: need disk count $need, have $have disks"
        rlLogWarning "环境不满足: 磁盘需要 $need 块, 实际 $have 块"
        exit 0
    fi
    rlLogInfo "hw: Disk OK ($have >= $need)"
    return 0
}

# ── hwNetCheck：检查网卡数量 ────────────────────────────────
hwNetCheck() {
    local need
    need=$(_hwFmfGet "hardware-require" "net" "${1:-main.fmf}")
    [ -z "$need" ] && return 0

    # 统计物理网卡数量（排除 lo 环回接口）
    local have=$(ip -o link show 2>/dev/null | grep -v 'lo' | grep -c 'state UP')
    [ -z "$have" ] && have=0

    if ! _hwCompare "$have" "$need" int; then
        echo "SKIP: need net count $need, have $have interfaces"
        rlLogWarning "环境不满足: 网卡需要 $need 个, 实际 $have 个"
        exit 0
    fi
    rlLogInfo "hw: Net OK ($have >= $need)"
    return 0
}

# ── hwVerify：综合检查所有 hardware-require 字段 ───────────
# 建议在 rlPhaseStartTest 开头调用
hwVerify() {
    local fmf="${1:-main.fmf}"

    # 检查是否声明了 hardware-require
    if ! grep -q "^hardware-require:" "$fmf" 2>/dev/null; then
        return 0  # 未声明，无需检查
    fi

    rlLogInfo "===== 硬件环境检查 ====="
    hwServerVerify "$fmf"
    hwCpuCheck "$fmf"
    hwMemCheck "$fmf"
    hwDiskCheck "$fmf"
    hwNetCheck "$fmf"
    rlLogInfo "===== 硬件环境检查通过 ====="
    return 0
}

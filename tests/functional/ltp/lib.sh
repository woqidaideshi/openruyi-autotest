# library-prefix = ltp
#
# LTP suite-level shared library
# Uses flag-file + reference counting to ensure LTP is installed
# only ONCE across all test cases.
#
# Strategy:
#   1. Try dnf install (fast if package is in repo)
#   2. If dnf fails or kirk not found, compile from source (tag 20250930)
#
# Reference: https://github.com/linux-test-project/ltp
# Docs: https://git.openruyi.cn/woqidaideshi/docs/src/branch/main/guide/Testing-Guide/Testing-Guide.md#11-ltp
# Usage: . "$(dirname "$0")/../../lib.sh"; ltpSetup

LTP_FLAG="/tmp/.beakerlib_ltp_suite"
LTP_INSTALL_DIR="/opt/ltp"
LTP_TAG="20250930"

_ltpSetupPath() {
    export PATH="$LTP_INSTALL_DIR:$PATH"
}

ltpSetup() {
    if [ ! -f "$LTP_FLAG" ]; then
        local method=""
        # Check if any working LTP (kirk) exists
        if command -v kirk >/dev/null 2>&1; then
            method="system"
            echo "installed=0" > "$LTP_FLAG"
        elif [ -x "$LTP_INSTALL_DIR/kirk" ]; then
            _ltpSetupPath
            method="source-cached"
            echo "installed=0" > "$LTP_FLAG"
        else
            rlLogInfo "安装 LTP（首次）..."
            # Try dnf first
            if echo openruyi | sudo -S dnf install -y ltp 2>/dev/null && command -v kirk >/dev/null 2>&1; then
                method="dnf"
                echo "installed=1" > "$LTP_FLAG"
            else
                # dnf failed or kirk not in PATH — compile from source
                rlLogInfo "dnf 安装失败或无 kirk，从源码编译（tag: $LTP_TAG）..."
                echo openruyi | sudo -S dnf install -y git make gcc gcc-c++ autoconf automake pkgconfig \
                    zlib-devel keyutils-libs-devel libtirpc-devel libmnl-devel libaio-devel \
                    libcap-devel openssl-devel numactl-devel 2>/dev/null || true
                if [ ! -d "$LTP_INSTALL_DIR" ]; then
                    git clone --depth 1 --branch "$LTP_TAG" https://github.com/linux-test-project/ltp.git "$LTP_INSTALL_DIR" 2>/dev/null || true
                fi
                if [ -f "$LTP_INSTALL_DIR/Makefile" ]; then
                    # Fix: listmount04.c uses struct mnt_id_req.spare which was
                    # removed in newer kernel headers (riscv64). Add a pre-build patch.
                    local lm_src="$LTP_INSTALL_DIR/testcases/kernel/syscalls/listmount/listmount04.c"
                    if [ -f "$lm_src" ]; then
                        grep -q 'spare' "$lm_src" 2>/dev/null && sed -i 's/req->spare = tc->spare;/\/\/ req->spare = tc->spare; (spare field removed from newer kernel)/' "$lm_src" || true
                    fi
                    cd "$LTP_INSTALL_DIR" && make autotools && ./configure --prefix="$LTP_INSTALL_DIR" --with-open-posix-testsuite && make -j$(nproc) && sudo make install 2>&1 | tail -3
                fi
                _ltpSetupPath
                if command -v kirk >/dev/null 2>&1; then
                    method="source"
                    echo "installed=2" > "$LTP_FLAG"
                else
                    rlLogWarning "LTP 源码编译失败，测试可能无法执行"
                    method="failed"
                    echo "installed=3" > "$LTP_FLAG"
                fi
            fi
        fi
        echo "ref=1" >> "$LTP_FLAG"
        rlLogInfo "LTP 安装方式: $method"
    else
        local ref
        ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP 已安装，引用计数: $ref"
        # Restore PATH if source install
        if [ -x "$LTP_INSTALL_DIR/kirk" ]; then
            _ltpSetupPath
        fi
    fi

    rlCleanupAppend "ltpCleanup"
}

ltpCleanup() {
    if [ ! -f "$LTP_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        local installed
        installed=$(grep "^installed=" "$LTP_FLAG" | cut -d= -f2)
        case "$installed" in
            1) echo openruyi | sudo -S dnf remove -y ltp 2>/dev/null || true
               rlLogInfo "已卸载 LTP（dnf 安装）" ;;
            2) rm -rf "$LTP_INSTALL_DIR"
               rlLogInfo "已删除 LTP 源码目录" ;;
        esac
        rm -f "$LTP_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP 保留（还有 $ref 个测试未完成）"
    fi
}

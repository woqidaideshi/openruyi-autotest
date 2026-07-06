# library-prefix = ltp_posix
#
# LTP POSIX 兼容性测试套件 — 共享库
# 合并原 setup.sh + helper.sh，使用 flag-file + 引用计数
# 确保 LTP 只 clone/build 一次，所有测试共享同一构建产物。
#
# Usage in each test file:
#   . "$(dirname "$0")/../../lib.sh"    # from test_ltp_posix_xxx/ subdirectories

LTP_FLAG="/tmp/.beakerlib_ltp_posix_suite"
LTP_DIR="/tmp/ltp-posix"
LTP_BUILD_DIR="$LTP_DIR/testcases/open_posix_testsuite"
SUDO_PASSWORD="openruyi"

# ── 引用计数 Setup ──

ltpPosixSetup() {
    if [ ! -f "$LTP_FLAG" ]; then
        DEPS="git gcc make"
        MISSING_DEPS=""
        for dep in $DEPS; do
            if ! rpm -q "$dep" 2>/dev/null; then
                MISSING_DEPS="$MISSING_DEPS $dep"
            fi
        done
        if [ -n "$MISSING_DEPS" ]; then
            echo "$SUDO_PASSWORD" | sudo -S dnf install -y $MISSING_DEPS 2>/dev/null || true
            echo "installed_deps=1" > "$LTP_FLAG"
        else
            echo "installed_deps=0" > "$LTP_FLAG"
        fi

        if [ ! -d "$LTP_DIR" ]; then
            mkdir -p /tmp
            cd /tmp
            rm -rf ltp-posix
            if git clone --depth 1 https://github.com/linux-test-project/ltp.git ltp-posix 2>/dev/null; then
                cd "$LTP_DIR"
                make autotools 2>/dev/null || true
                cd "$LTP_BUILD_DIR"
                ./configure 2>/dev/null || true
                make -j$(nproc) 2>/dev/null || true
                make top_builddir="$LTP_DIR" -C conformance all 2>/dev/null || true
                echo "installed_ltp=1" >> "$LTP_FLAG"
                rlLogInfo "LTP POSIX 编译完成"
            else
                echo "installed_ltp=0" >> "$LTP_FLAG"
                rlLogWarning "LTP clone 失败，测试将被跳过"
            fi
        else
            echo "installed_ltp=0" >> "$LTP_FLAG"
            rlLogInfo "LTP 已存在"
        fi
        echo "ref=1" >> "$LTP_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP POSIX 已由其他测试初始化，引用计数: $ref"
    fi
    rlCleanupAppend "ltpPosixCleanup"
}

ltpPosixCleanup() {
    if [ ! -f "$LTP_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -rf "$LTP_DIR" 2>/dev/null || true
        if grep -q "^installed_deps=1" "$LTP_FLAG" 2>/dev/null; then
            echo "$SUDO_PASSWORD" | sudo -S dnf remove -y git gcc make 2>/dev/null || true
        fi
        rm -f "$LTP_FLAG"
        rlLogInfo "LTP POSIX 清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP POSIX 保留（还有 $ref 个测试未完成）"
    fi
}

# ── 原 helper.sh 函数 ──

# 在指定接口目录中编译并运行所有测试
run_posix_iface_test() {
    local iface="$1"
    local dir="$IFACE_DIR/$iface"
    local inc_dir="$LTP_BUILD_DIR/include"
    local lib_common="$LTP_BUILD_DIR/lib/common.c"

    if [ ! -d "$dir" ]; then
        rlLogWarning "SKIP: 接口目录不存在 $iface"
        return 0
    fi

    cd "$dir"

    # 1. 运行 .sh 脚本测试
    for test_sh in $(find . -maxdepth 1 -type f -name "*.sh" ! -name "Makefile" 2>/dev/null | sort); do
        local test_name="${iface}/$(basename "$test_sh")"
        if rlRun "echo $SUDO_PASSWORD | sudo -S sh $test_sh" 0 "POSIX $test_name"; then
            rlLogInfo "PASS: $test_name"
        else
            rlLogError "FAIL: $test_name"
        fi
    done

    # 2. 编译 .c 文件并运行（每接口最多 3 个样本）
    local c_count=0
    for src in $(find . -maxdepth 1 -type f -name "*.c" 2>/dev/null | sort); do
        local test_name="${iface}/$(basename "$src" .c)"
        local bin="/tmp/posix_test_$$_${c_count}"
        c_count=$((c_count + 1))
        if gcc -std=gnu11 -I"$inc_dir" -Wno-error=incompatible-pointer-types -o "$bin" "$lib_common" "$src" -lpthread -lrt -lm 2>/dev/null; then
            if rlRun "echo $SUDO_PASSWORD | sudo -S $bin" 0 "POSIX $test_name"; then
                rlLogInfo "PASS: $test_name"
            else
                rlLogError "FAIL: $test_name"
            fi
            rm -f "$bin"
        else
            rlLogWarning "SKIP: 编译失败 $test_name"
        fi
        [ "$c_count" -ge 3 ] && break
    done
    return 0
}

# library-prefix = perf_unixbench
#
# Performance UnixBench suite-level shared library
# Uses flag-file + reference counting to ensure UnixBench
# is cloned and built only ONCE across all test cases.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_unixbench_xxx/ subdirectories

UNIXBENCH_FLAG="/tmp/.beakerlib_unixbench_suite"
UNIXBENCH_DIR="/tmp/unixbench"
SUDO_PASSWORD="openruyi"

unixbenchSetup() {
    if [ ! -f "$UNIXBENCH_FLAG" ]; then
        # Install build dependencies
        MISSING=""
        for dep in git gcc make perl; do
            if ! rpm -q "$dep" 2>/dev/null; then
                MISSING="$MISSING $dep"
            fi
        done
        if [ -n "$MISSING" ]; then
            echo "$SUDO_PASSWORD" | sudo -S dnf install -y $MISSING 2>/dev/null || true
            echo "installed_deps=1" > "$UNIXBENCH_FLAG"
        else
            echo "installed_deps=0" > "$UNIXBENCH_FLAG"
        fi

        # Clone and build UnixBench (if not already present)
        if [ ! -f "$UNIXBENCH_DIR/Run" ]; then
            cd /tmp
            rm -rf unixbench
            git clone --depth 1 https://github.com/kdlucas/byte-unixbench.git unixbench 2>/dev/null && {
                cd "$UNIXBENCH_DIR/UnixBench"
                make -j$(nproc) 2>/dev/null || true
                echo "built=1" >> "$UNIXBENCH_FLAG"
                rlLogInfo "UnixBench 编译完成"
            } || {
                echo "built=0" >> "$UNIXBENCH_FLAG"
                rlLogWarning "UnixBench clone 失败"
            }
        else
            echo "built=0" >> "$UNIXBENCH_FLAG"
            rlLogInfo "UnixBench 已存在"
        fi
        echo "ref=1" >> "$UNIXBENCH_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$UNIXBENCH_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$UNIXBENCH_FLAG"
        rlLogInfo "UnixBench 已由其他测试初始化，引用计数: $ref"
    fi
    rlCleanupAppend "unixbenchCleanup"
}

unixbenchCleanup() {
    if [ ! -f "$UNIXBENCH_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$UNIXBENCH_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -rf "$UNIXBENCH_DIR" 2>/dev/null || true
        if grep -q "^installed_deps=1" "$UNIXBENCH_FLAG" 2>/dev/null; then
            echo "$SUDO_PASSWORD" | sudo -S dnf remove -y git gcc make perl 2>/dev/null || true
        fi
        rm -f "$UNIXBENCH_FLAG"
        rlLogInfo "UnixBench 清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$UNIXBENCH_FLAG"
        rlLogInfo "UnixBench 保留（还有 $ref 个测试未完成）"
    fi
}
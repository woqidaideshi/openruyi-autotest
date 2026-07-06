# library-prefix = jotai
#
# Jotai suite-level shared library
# Clones jotai-benchmarks repo, compiles benchmarks with gcc and clang
# at different optimization levels, verifies runtime output correctness.
#
# Jotai is a benchmark suite of real C functions extracted from
# open-source projects. Each benchmark is a standalone C file with
# a driver that tests the function.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_jotai_*/ subdirectories

JOTAI_FLAG="/tmp/.beakerlib_compiler_jotai_suite"
JOTAI_DIR="/tmp/jotai-benchmarks"

jotaiSetup() {
    if [ ! -f "$JOTAI_FLAG" ]; then
        # Install dependencies
        if ! rpm -q gcc 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y gcc 2>/dev/null
        fi
        if ! rpm -q clang 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y clang 2>/dev/null
        fi
        
        # Clone jotai-benchmarks if not present
        if [ ! -d "$JOTAI_DIR" ]; then
            git clone --depth 1 https://github.com/lac-dcc/jotai-benchmarks.git "$JOTAI_DIR" 2>/dev/null
            if [ -d "$JOTAI_DIR" ] && [ -d "$JOTAI_DIR/benchmarks" ]; then
                echo "cloned=1" > "$JOTAI_FLAG"
                rlLogInfo "已克隆 jotai-benchmarks"
            else
                rlLogWarning "jotai-benchmarks 克隆失败"
                echo "cloned=0" > "$JOTAI_FLAG"
            fi
        else
            echo "cloned=0" > "$JOTAI_FLAG"
            rlLogInfo "jotai-benchmarks 已存在"
        fi
        echo "ref=1" >> "$JOTAI_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$JOTAI_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$JOTAI_FLAG"
        rlLogInfo "jotai 引用计数: $ref"
    fi
    rlCleanupAppend "jotaiCleanup"
}

jotaiCleanup() {
    if [ ! -f "$JOTAI_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$JOTAI_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$JOTAI_FLAG"
        rlLogInfo "jotai 测试套清理完成（保留 repo 以供复用）"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$JOTAI_FLAG"
        rlLogInfo "jotai 保留（还有 $ref 个测试）"
    fi
}

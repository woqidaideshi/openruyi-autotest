# library-prefix = csmith
#
# Csmith suite-level shared library
# Random C program generator for compiler differential testing.
# Generates random C99 programs, compiles with gcc and clang,
# compares runtime outputs to detect compiler bugs.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_csmith_*/ subdirectories

CSMITH_FLAG="/tmp/.beakerlib_compiler_csmith_suite"

csmithSetup() {
    if [ ! -f "$CSMITH_FLAG" ]; then
        if ! rpm -q csmith 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y csmith 2>/dev/null
            if ! rpm -q csmith 2>/dev/null; then
                rlLogWarning "csmith 安装失败"
                echo "installed=0" > "$CSMITH_FLAG"
            else
                echo "installed=1" > "$CSMITH_FLAG"
                rlLogInfo "已安装 csmith（首次）"
            fi
        else
            echo "installed=0" > "$CSMITH_FLAG"
            rlLogInfo "csmith 已存在"
        fi
        echo "ref=1" >> "$CSMITH_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$CSMITH_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$CSMITH_FLAG"
        rlLogInfo "csmith 引用计数: $ref"
    fi
    rlCleanupAppend "csmithCleanup"
}

csmithCleanup() {
    if [ ! -f "$CSMITH_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$CSMITH_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$CSMITH_FLAG"; then
            echo openruyi | sudo -S dnf remove -y csmith 2>/dev/null || true
            rlLogInfo "已卸载 csmith"
        fi
        rm -f "$CSMITH_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$CSMITH_FLAG"
        rlLogInfo "csmith 保留（还有 $ref 个测试）"
    fi
}

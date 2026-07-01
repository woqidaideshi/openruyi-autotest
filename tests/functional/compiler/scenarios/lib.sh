# library-prefix = compiler_scenarios
#
# Compiler Scenarios suite-level shared library
# Tests various compilation scenarios: standards, optimization,
# warnings, debug, linking, preprocessing, assembly, sanitizers.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_scenarios_*/ subdirectories

SCENARIOS_FLAG="/tmp/.beakerlib_compiler_scenarios_suite"

scenariosSetup() {
    if [ ! -f "$SCENARIOS_FLAG" ]; then
        # Ensure compilers are installed
        if ! rpm -q gcc 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y gcc 2>/dev/null
        fi
        if ! rpm -q gcc-c++ 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y gcc-c++ 2>/dev/null
        fi
        if ! rpm -q clang 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y clang 2>/dev/null
        fi
        
        # Install gdb if not present (for debug test)
        if ! rpm -q gdb 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y gdb 2>/dev/null
        fi
        
        echo "ref=1" > "$SCENARIOS_FLAG"
        rlLogInfo "编译场景测试套初始化完成"
    else
        local ref
        ref=$(grep "^ref=" "$SCENARIOS_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$SCENARIOS_FLAG"
        rlLogInfo "scenarios 引用计数: $ref"
    fi
    rlCleanupAppend "scenariosCleanup"
}

scenariosCleanup() {
    if [ ! -f "$SCENARIOS_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$SCENARIOS_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$SCENARIOS_FLAG"
        rlLogInfo "编译场景测试套清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$SCENARIOS_FLAG"
        rlLogInfo "scenarios 保留（还有 $ref 个测试）"
    fi
}

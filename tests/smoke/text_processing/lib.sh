# library-prefix = smoke_text_processing
#
# Smoke text_processing suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (gawk coreutils findutils grep sed) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_smoke_xxx/ subdirectories

SMOKE_TEXT_PROCESSING_FLAG="/tmp/.beakerlib_smoke_text_processing_suite"

smokeTextProcessingSetup() {
    if [ ! -f "$SMOKE_TEXT_PROCESSING_FLAG" ]; then
        echo "installed=0" > "$SMOKE_TEXT_PROCESSING_FLAG"
        echo "ref=1" >> "$SMOKE_TEXT_PROCESSING_FLAG"
        rlLogInfo "smoke-text_processing: 核心依赖已确认可用"
    else
        local ref
        ref=$(grep "^ref=" "$SMOKE_TEXT_PROCESSING_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_TEXT_PROCESSING_FLAG"
        rlLogInfo "smoke-text_processing 已由其他测试初始化，引用计数: $ref"
    fi
    rlCleanupAppend "smokeTextProcessingCleanup"
}

smokeTextProcessingCleanup() {
    if [ ! -f "$SMOKE_TEXT_PROCESSING_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$SMOKE_TEXT_PROCESSING_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$SMOKE_TEXT_PROCESSING_FLAG"
        rlLogInfo "smoke-text_processing: 清理完成（最后一个测试）"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_TEXT_PROCESSING_FLAG"
        rlLogInfo "smoke-text_processing: 保留（还有 $ref 个测试未完成）"
    fi
}

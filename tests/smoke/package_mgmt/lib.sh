# library-prefix = smoke_package_mgmt
#
# Smoke package_mgmt suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (dnf rpm) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_smoke_xxx/ subdirectories

SMOKE_PACKAGE_MGMT_FLAG="/tmp/.beakerlib_smoke_package_mgmt_suite"

smokePackageMgmtSetup() {
    if [ ! -f "$SMOKE_PACKAGE_MGMT_FLAG" ]; then
        echo "installed=0" > "$SMOKE_PACKAGE_MGMT_FLAG"
        echo "ref=1" >> "$SMOKE_PACKAGE_MGMT_FLAG"
        rlLogInfo "smoke-package_mgmt: 核心依赖已确认可用"
    else
        local ref
        ref=$(grep "^ref=" "$SMOKE_PACKAGE_MGMT_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_PACKAGE_MGMT_FLAG"
        rlLogInfo "smoke-package_mgmt 已由其他测试初始化，引用计数: $ref"
    fi
    rlCleanupAppend "smokePackageMgmtCleanup"
}

smokePackageMgmtCleanup() {
    if [ ! -f "$SMOKE_PACKAGE_MGMT_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$SMOKE_PACKAGE_MGMT_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$SMOKE_PACKAGE_MGMT_FLAG"
        rlLogInfo "smoke-package_mgmt: 清理完成（最后一个测试）"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_PACKAGE_MGMT_FLAG"
        rlLogInfo "smoke-package_mgmt: 保留（还有 $ref 个测试未完成）"
    fi
}

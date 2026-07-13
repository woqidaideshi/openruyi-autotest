# library-prefix = acl
#
# ACL suite-level shared library
# Uses flag-file + reference counting to ensure the acl package
# is installed only ONCE and uninstalled only ONCE across all
# test cases, regardless of execution mode (sequential or parallel).
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_acl_xxx/ subdirectories
#   . "$(dirname "$0")/lib.sh"       # from acl/ directory
#
# Then call:  aclSetup   in rlPhaseStartSetup
# The cleanup is auto-registered via rlCleanupAppend.

ACL_FLAG="/tmp/.beakerlib_acl_suite"

aclSetup() {
    if [ ! -f "$ACL_FLAG" ]; then
        # First test to arrive: install if needed
        if ! rpm -q acl 2>/dev/null; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y acl 2>/dev/null
            echo "installed=1" > "$ACL_FLAG"
            rlLogInfo "已安装 acl 软件包（首次）"
        else
            echo "installed=0" > "$ACL_FLAG"
            rlLogInfo "acl 软件包已存在"
        fi
        echo "ref=1" >> "$ACL_FLAG"
    else
        # Subsequent tests: increment ref count, skip install
        local ref
        ref=$(grep "^ref=" "$ACL_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$ACL_FLAG"
        rlLogInfo "acl 已由其他测试安装，引用计数: $ref"
    fi

    # Register cleanup — runs at rlJournalEnd regardless of test failure
    # Ref-counting ensures only the LAST test actually uninstalls
    rlCleanupAppend "aclCleanup"
}

aclCleanup() {
    if [ ! -f "$ACL_FLAG" ]; then
        return 0
    fi

    local ref
    ref=$(grep "^ref=" "$ACL_FLAG" | cut -d= -f2)
    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then
        # Last test to leave: uninstall if we installed
        if grep -q "^installed=1" "$ACL_FLAG"; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y acl 2>/dev/null || true
            rlLogInfo "已卸载 acl 软件包（最后一个测试）"
        fi
        rm -f "$ACL_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$ACL_FLAG"
        rlLogInfo "acl 保留（还有 $ref 个测试未完成）"
    fi
}

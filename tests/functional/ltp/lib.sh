# library-prefix = ltp
#
# LTP suite-level shared library
# Uses flag-file + reference counting to ensure the ltp package
# is installed only ONCE and uninstalled only ONCE across all
# test cases, regardless of execution mode (sequential or parallel).
#
# Usage in each test file:
#   . "$(dirname "$0")/../../lib.sh"    # from test_ltp_<suite>_<case>/ subdirectories
#
# Then call:  ltpSetup   in rlPhaseStartSetup
# The cleanup is auto-registered via rlCleanupAppend.

LTP_FLAG="/tmp/.beakerlib_ltp_suite"

ltpSetup() {
    if [ ! -f "$LTP_FLAG" ]; then
        # First test to arrive: install if needed
        if ! rpm -q ltp 2>/dev/null; then
            rlRun "echo openruyi | sudo -S dnf install -y ltp" 0 "安装 LTP 测试套件（首次）"
            echo "installed=1" > "$LTP_FLAG"
        else
            echo "installed=0" > "$LTP_FLAG"
            rlLogInfo "LTP 软件包已存在"
        fi
        echo "ref=1" >> "$LTP_FLAG"
    else
        # Subsequent tests: increment ref count, skip install
        local ref
        ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP 已由其他测试安装，引用计数: $ref"
    fi

    # Register cleanup — runs at rlJournalEnd regardless of test failure
    rlCleanupAppend "ltpCleanup"
}

ltpCleanup() {
    if [ ! -f "$LTP_FLAG" ]; then
        return 0
    fi

    local ref
    ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then
        # Last test to leave: uninstall if we installed
        if grep -q "^installed=1" "$LTP_FLAG"; then
            echo openruyi | sudo -S dnf remove -y ltp 2>/dev/null || true
            rlLogInfo "已卸载 LTP 软件包（最后一个测试）"
        fi
        rm -f "$LTP_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP 保留（还有 $ref 个测试未完成）"
    fi
}

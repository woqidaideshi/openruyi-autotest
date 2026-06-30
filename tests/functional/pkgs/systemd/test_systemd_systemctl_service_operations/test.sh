#!/bin/bash
# Functional test: systemd - systemctl-service-operations
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        systemdSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "systemctl-service-operations"
        rlRun "systemctl try-restart systemd-journald.service 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "systemctl try-restart"
        rlRun "systemctl reload-or-restart systemd-journald.service 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "systemctl reload-or-restart"
        rlRun "systemctl reset-failed 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "systemctl reset-failed"
        rlRun "systemctl daemon-reload 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "systemctl daemon-reload"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # systemd 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

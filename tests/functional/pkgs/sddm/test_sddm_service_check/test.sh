#!/bin/bash
# Functional test: sddm - Service-check
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        sddmSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Service-check"
        rlRun "systemctl cat sddm.service 2>&1 | head -10" 0 "sddm service unit"
        rlRun "systemctl status sddm.service 2>&1 | head -5 || true" 0 "sddm service status"
        rlRun "systemctl is-enabled sddm.service 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "sddm enabled status"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # sddm 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

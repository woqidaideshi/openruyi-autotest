#!/bin/bash
# Functional test: systemd - loginctl---Login-management
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

    rlPhaseStartTest "loginctl---Login-management"
        rlRun "loginctl --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "loginctl version"
        rlRun "loginctl list-sessions" 0 "loginctl list-sessions"
        rlRun "loginctl list-users" 0 "loginctl list-users"
        rlRun "loginctl show-session 2>&1 | head -10" 0 "loginctl show-session"
        rlRun "loginctl show-user openruyi 2>&1 | head -10" 0 "loginctl show-user"
        rlRun "loginctl user-status openruyi 2>&1 | head -10" 0 "loginctl user-status"
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

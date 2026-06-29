#!/bin/bash
# Functional test: systemd-timesyncd - timesyncd - NTP-management
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        systemdTimesyncdSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "timesyncd - NTP-management"
        rlRun "timedatectl show-timesync --property=FallbackNTPServers 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "Fallback NTP servers"
        rlRun "timedatectl show-timesync --property=ServerName 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "Current NTP server"
        rlRun "timedatectl show-timesync --property=ServerAddress 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "Server address"
        rlRun "timedatectl ntp-servers 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "NTP servers list"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # systemd-timesyncd 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

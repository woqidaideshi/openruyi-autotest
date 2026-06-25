#!/bin/bash
# Functional test: systemd - systemd-escape
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

    rlPhaseStartTest "systemd-escape"
        rlRun "systemd-escape \"hello world\"" 0 "systemd-escape: basic escape"
        rlRun "systemd-escape --path \"/usr/bin/test\"" 0 "systemd-escape --path: path escape"
        rlRun "systemd-escape -u \"hello\\x20world\"" 0 "systemd-escape -u: unescape"
        rlRun "systemd-escape --suffix=mount \"/mnt/data\"" 0 "systemd-escape --suffix"
        rlRun "systemd-escape --template=\"test@.service\" instance" 0 "systemd-escape --template"
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

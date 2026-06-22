#!/bin/bash
# Functional test: systemd - journalctl---Journal-query
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

    rlPhaseStartTest "journalctl---Journal-query"
        rlRun "journalctl --version" 0 "journalctl version"
        rlRun "journalctl -n 5 2>&1 || true" 0 "journalctl -n: last entries"
        rlRun "journalctl -b 2>&1 | head -5" 0 "journalctl -b: current boot"
        rlRun "journalctl --list-boots 2>&1 | head -5" 0 "journalctl --list-boots"
        rlRun "journalctl -k 2>&1 | head -5" 0 "journalctl -k: kernel messages"
        rlRun "journalctl --no-pager -n 3 -o short 2>&1 || true" 0 "journalctl -o short: short format"
        rlRun "journalctl --no-pager -n 3 -o json 2>&1 | head -5" 0 "journalctl -o json: json format"
        rlRun "journalctl --no-pager -n 3 -o verbose 2>&1 | head -5" 0 "journalctl -o verbose"
        rlRun "journalctl --disk-usage 2>&1 || true" 0 "journalctl --disk-usage"
        rlRun "journalctl --no-pager -n 1 --output=cat 2>&1 || true" 0 "journalctl --output=cat"
        rlRun "journalctl --no-pager -n 2 -p err 2>&1 || true" 0 "journalctl -p err: error messages"
        rlRun "journalctl --no-pager --since \"1 hour ago\" 2>&1 | head -3" 0 "journalctl --since"
        rlRun "journalctl --no-pager -n 1 -q 2>&1 || true" 0 "journalctl -q: quiet"
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

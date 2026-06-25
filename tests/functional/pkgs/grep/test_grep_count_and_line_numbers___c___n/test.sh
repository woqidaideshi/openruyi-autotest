#!/bin/bash
# Functional test: grep - Count-and-line-numbers---c---n
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        grepSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Count-and-line-numbers---c---n"
        rlRun "grep -c Hello test1.txt" 0 "Count matches with -c"
        rlRun "test $(grep -c Hello test1.txt) -ge 2" 0 "Verify count >= 2"
        rlRun "grep -n Hello test1.txt" 0 "Show line numbers with -n"
        rlRun "grep -n Hello test1.txt | grep -q \"^[0-9]:\"" 0 "Verify line number format"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # grep 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

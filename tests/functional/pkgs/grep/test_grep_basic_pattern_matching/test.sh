#!/bin/bash
# Functional test: grep - Basic-pattern-matching
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

    rlPhaseStartTest "Basic-pattern-matching"
        rlRun "grep Hello test1.txt" 0 "Basic grep for Hello"
        rlRun "test $(grep Hello test1.txt | wc -l) -ge 2" 0 "Verify multiple matches"
        rlRun "echo \"hello pipe\" | grep hello" 0 "Grep from pipe"
        rlRun "grep Hello test1.txt test2.txt" 0 "Grep across multiple files"
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

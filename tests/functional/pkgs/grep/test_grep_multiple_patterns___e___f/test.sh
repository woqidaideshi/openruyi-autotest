#!/bin/bash
# Functional test: grep - Multiple-patterns---e---f
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

    rlPhaseStartTest "Multiple-patterns---e---f"
        rlRun "grep -e Hello -e apple test1.txt test2.txt" 0 "Multiple patterns with -e"
        rlRun "grep -f patterns.txt test1.txt test2.txt" 0 "Patterns from file with -f"
        rlRun "test $(grep -m1 Hello test1.txt | wc -l) -eq 1" 0 "Max count: stop after first match"
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

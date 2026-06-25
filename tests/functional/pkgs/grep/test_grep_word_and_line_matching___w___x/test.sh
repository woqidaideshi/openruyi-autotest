#!/bin/bash
# Functional test: grep - Word-and-line-matching---w---x
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

    rlPhaseStartTest "Word-and-line-matching---w---x"
        rlRun "echo \"helloworld\" > word_test.txt" 0 "Create word test file"
        rlRun "echo \"hello world\" >> word_test.txt" 0 "Add line with separate words"
        rlRun "test $(grep -w hello word_test.txt | wc -l) -eq 1" 0 "Whole word match: hello matches only standalone"
        rlRun "echo \"exact match\" > line_test.txt" 0 "Create line test file"
        rlRun "echo \"not exact match here\" >> line_test.txt" 0 "Add different line"
        rlRun "test $(grep -x \"exact match\" line_test.txt | wc -l) -eq 1" 0 "Whole line exact match"
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

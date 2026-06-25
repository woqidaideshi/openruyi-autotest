#!/bin/bash
# Functional test: coreutils - File-viewing--head--tail--tac--nl
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "File-viewing--head--tail--tac--nl"
        rlRun "head -n 5 lines.txt" 0 "head -n 5: first 5 lines"
        rlRun "test $(head -n 3 lines.txt | wc -l) -eq 3" 0 "head -n 3: verify count"
        rlRun "head -c 10 lines.txt" 0 "head -c 10: first 10 bytes"
        rlRun "tail -n 5 lines.txt" 0 "tail -n 5: last 5 lines"
        rlRun "test $(tail -n 3 lines.txt | wc -l) -eq 3" 0 "tail -n 3: verify count"
        rlRun "test $(tail -n +18 lines.txt | wc -l) -eq 3" 0 "tail -n +18: from line 18"
        rlRun "tail -c 10 lines.txt" 0 "tail -c 10: last 10 bytes"
        rlRun "tac lines.txt" 0 "tac reverse lines"
        rlRun "test \"$(head -1 lines.txt)\" = \"$(tac lines.txt | tail -1)\"" 0 "tac: first becomes last"
        rlRun "nl lines.txt" 0 "nl number lines"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

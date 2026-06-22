#!/bin/bash
# Functional test: coreutils - Text-processing-II--paste--comm--join--fmt--fold--
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

    rlPhaseStartTest "Text-processing-II--paste--comm--join--fmt--fold--"
        rlRun "paste paste1.txt paste2.txt" 0 "paste merge files side by side"
        rlRun "paste -d: paste1.txt paste2.txt" 0 "paste -d: custom delimiter"
        rlRun "paste -s paste1.txt paste2.txt" 0 "paste -s serial"
        rlRun "comm comm1.txt comm2.txt" 0 "comm compare sorted files"
        rlRun "join join1.txt join2.txt" 0 "join files on common field"
        rlRun "echo \"This is a long line that should be reformatted by fmt to a reasonable width\" | fmt" 0 "fmt reformat text"
        rlRun "echo \"short\" | fmt -w 10" 0 "fmt -w set width"
        rlRun "echo \"1234567890\" | fold -w 3" 0 "fold -w wrap at width"
        rlRun "pr lines.txt" 0 "pr paginate file"
        rlRun "pr -n lines.txt" 0 "pr -n number lines"
        rlRun "printf \"a\tb\n\" | expand" 0 "expand tabs to spaces"
        rlRun "printf \"a    b\n\" | unexpand -a" 0 "unexpand -a spaces to tabs"
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

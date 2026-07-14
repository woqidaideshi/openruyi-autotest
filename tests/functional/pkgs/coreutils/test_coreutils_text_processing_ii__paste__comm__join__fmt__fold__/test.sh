#!/bin/bash
# Functional test: coreutils - Text-processing-II--paste--comm--join--fmt--fold--
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    coreutilsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
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
    rlRun "printf \"a b\n\" | unexpand -a" 0 "unexpand -a spaces to tabs"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # coreutils Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

#!/bin/bash
# Functional test: coreutils - File-viewing--head--tail--tac--nl
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


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # coreutils Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

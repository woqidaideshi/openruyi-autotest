#!/bin/bash
# Functional test: coreutils - Counting-and-statistics--wc--du--df--stat
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

 rlPhaseStartTest "Counting-and-statistics--wc--du--df--stat"
 rlRun "wc -l lines.txt" 0 "wc -l line count"
 rlRun "test $(wc -l < lines.txt) -eq 20" 0 "wc -l: 20 lines"
 rlRun "wc -c lines.txt" 0 "wc -c byte count"
 rlRun "wc -w lines.txt" 0 "wc -w word count"
 rlRun "wc -m lines.txt" 0 "wc -m character count"
 rlRun "du -sh ." 0 "du -sh summary human"
 rlRun "du -h a/" 0 "du -h directory usage"
 rlRun "df -h" 0 "df -h human readable"
 rlRun "df -h / | tail -1" 0 "df: root filesystem"
 rlRun "stat file1.txt" 0 "stat file status"
 rlRun "stat -c \"%s %n\" file1.txt" 0 "stat -c format output"
 rlRun "stat -f /" 0 "stat -f filesystem status"
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

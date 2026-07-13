#!/bin/bash
# Functional test: grep - Basic-pattern-matching
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 grepSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Basic-pattern-matching"
 rlRun "grep Hello test1.txt" 0 "Basic grep for Hello"
 rlRun "test $(grep Hello test1.txt | wc -l) -ge 2" 0 "Verify multiple matches"
 rlRun "echo \"hello pipe\" | grep hello" 0 "Grep from pipe"
 rlRun "grep Hello test1.txt test2.txt" 0 "Grep across multiple files"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # grep Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

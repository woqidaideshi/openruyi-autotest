#!/bin/bash
# Functional test: coreutils - Boolean-and-condition--true--false--test
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

 rlPhaseStartTest "Boolean-and-condition--true--false--test"
 rlRun "true" 0 "true returns success"
 rlRun "false" 1 "false returns failure"
 rlRun "test -f file1.txt" 0 "test -f: file exists"
 rlRun "test -d ls_testdir" 0 "test -d: directory exists"
 rlRun "test \"abc\" = \"abc\"" 0 "test string equality"
 rlRun "test 5 -gt 3" 0 "test numeric comparison"
 rlRun "[ -f file1.txt ]" 0 "[ -f: file exists"
 rlRun "[ \"x\" = \"x\" ]" 0 "[ string equality"
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

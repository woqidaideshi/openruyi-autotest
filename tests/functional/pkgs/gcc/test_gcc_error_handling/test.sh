#!/bin/bash
# Functional test: gcc - Error-handling
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 gccSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Error-handling"
 rlRun "gcc bad_syntax.c 2>&1" 1-255 "Test syntax error detection"
 rlRun "gcc nonexistent.c 2>&1" 1-255 "Test missing file error"
 rlRun "gcc bad_func.c 2>&1" 1-255 "Test undefined function error"
 rlRun "gcc -Wall bad_type.c -o bad_type 2>&1" 0 "Test type mismatch warning"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # gcc Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

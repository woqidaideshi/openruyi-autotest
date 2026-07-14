#!/bin/bash
# Smoke test: filesystem - rm delete file and directory
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeFSSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "touch rm_test.txt" 0 "Create test file"
 rlRun "mkdir rm_dir" 0 "Create test directory"
 rlPhaseEnd

 rlPhaseStartTest "rm deletefileanddirectory"
 rlRun "rm rm_test.txt" 0 "rm deletefile"
 rlRun "test ! -f rm_test.txt" 0 "filealreadydelete"
 rlRun "rm -rf rm_dir" 0 "rm -rf deletedirectory"
 rlRun "test ! -d rm_dir" 0 "directoryalreadydelete"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
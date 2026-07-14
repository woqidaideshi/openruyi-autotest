#!/bin/bash
# Smoke test: permissions - chmod -R recursive
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokePermissionsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "mkdir -p sub/nested; touch sub/nested/file.txt" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "chmod -R recursive"
 rlRun 'chmod -R 755 sub' 0 "chmod -R recursive"
 rlRun 'test -r sub/nested/file.txt' 0 "recursivepostfilereadable"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
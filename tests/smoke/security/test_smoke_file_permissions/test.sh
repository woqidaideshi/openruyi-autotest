#!/bin/bash
# Smoke test: security - chmod setpermission
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeSecuritySetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "echo "data" > f.txt" 0 "Create test data"
 rlRun "chmod +x f.txt" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "chmod setpermission"
 rlRun 'chmod 644 f.txt' 0 "chmod setpermission"
 rlRun 'test -r f.txt' 0 "filereadable"
 rlRun 'test -w f.txt' 0 "filecanwrite"
 rlRun 'test -x f.txt' 0 "filecanExecute"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
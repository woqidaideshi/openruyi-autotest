#!/bin/bash
# Smoke test: scripting - tee writefile
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeScriptingSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "echo "data" | tee out.txt > /dev/null" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "tee writefile"
 rlRun 'test -f out.txt' 0 "tee writefile"
 rlRun 'grep data out.txt' 0 "tee contentcorrect"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
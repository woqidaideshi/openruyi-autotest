#!/bin/bash
# Smoke test: text_processing - find by namesearch
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeTextProcessingSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "touch found.txt; mkdir sub" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "find by namesearch"
 rlRun 'find. -name "found.txt"' 0 "find by namesearch"
 rlRun 'find. -type d' 0 "find typedirectory"
 rlRun 'find. -type f' 0 "find typefile"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
#!/bin/bash

# Smoke test: text_processing - diff detect diff

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeTextProcessingSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 rlRun "echo "a" > f1; echo "b" > f2" 0 "Create test data"

 rlRun "echo "a" > f3; echo "a" > f4" 0 "Create test data"



 rlPhaseEnd



 rlPhaseStartTest "diff detect diff"

 rlRun 'diff f1 f2' 1 "diff detect diff"

 rlRun 'diff f3 f4' 0 "diff file"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd
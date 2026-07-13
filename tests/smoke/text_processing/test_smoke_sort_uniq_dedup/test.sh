#!/bin/bash
# Smoke test: text_processing - sort 
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeTextProcessingSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "cat > nums.txt << EOF" 0 "Create test data"
 rlRun "3" 0 "Create test data"
 rlRun "1" 0 "Create test data"
 rlRun "2" 0 "Create test data"
 rlRun "1" 0 "Create test data"
 rlRun "3" 0 "Create test data"
 rlRun "EOF" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "sort "
 rlRun'sort nums.txt' 0 "sort "
 rlRun'sort -n nums.txt' 0 "sort -n countvalue"
 rlRun'sort nums.txt | uniq' 0 "sort|uniq "
 rlRun'sort nums.txt | uniq | wc -l' 0 "post3lines"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
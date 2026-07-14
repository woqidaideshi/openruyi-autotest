#!/bin/bash

# Smoke test: text_processing - grep basic search

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeTextProcessingSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 cat > fruits.txt << EOF

 apple

 banana

 Apple pie

 orange

 EOF



 rlPhaseEnd



 rlPhaseStartTest "grep basic search"

 rlRun 'grep apple fruits.txt' 0 "grep basic search"

 rlRun 'grep -i apple fruits.txt' 0 "grep -i sizewrite"

 rlRun 'grep -c a fruits.txt' 0 "grep -c count"

 rlRun 'grep -v banana fruits.txt' 0 "grep -v "

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd
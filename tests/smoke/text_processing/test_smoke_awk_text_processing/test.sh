#!/bin/bash
# Smoke test: text_processing - awk print#one column
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeTextProcessingSetup
 rlRun "echo "a 1" 0 "Prepare environment"
 rlRun "b 2" 0 "Prepare environment"
 rlRun "c 3" > data.txt" 0 "Prepare environment"
 rlRun "rm -f data.txt" 0 "Prepare environment"

 rlPhaseEnd

 rlPhaseStartTest "awk print#one column"
 rlRun 'awk "{print \$1}" data.txt' 0 "awk print#one column"
 rlRun 'awk "{print \$2}" data.txt' 0 "awk print#list"
 rlRun 'awk "{sum+=\$2} END{print sum}" data.txt' 0 "awk and"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
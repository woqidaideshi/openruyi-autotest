#!/bin/bash
# Smoke test: text_processing - cut extract#one field
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeTextProcessingSetup
 rlRun "echo "a:b:c:d" | cut -d: -f1,3 | grep "a:c"" 0 "Prepare environment"

 rlPhaseEnd

 rlPhaseStartTest "cut extract#one field"
 rlRun 'echo "user:x:1000" | cut -d: -f1' 0 "cut extract#one field"
 rlRun 'echo "hello" | cut -c1-3' 0 "cut "
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
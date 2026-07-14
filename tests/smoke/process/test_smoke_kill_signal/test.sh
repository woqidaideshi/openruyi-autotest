#!/bin/bash
# Smoke test: process - kill signal
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeProcessSetup
 rlRun "sleep 10 &" 0 "Prepare environment"
 rlRun "PID=$!" 0 "Prepare environment"
 rlRun "sleep 1" 0 "Prepare environment"
 rlRun "if kill -0 $PID 2>/dev/null; then" 0 "Prepare environment"
 rlRun "echo "kill may not have worked"" 0 "Prepare environment"
 rlRun "fi" 0 "Prepare environment"

 rlPhaseEnd

 rlPhaseStartTest "kill signal"
 rlRun "kill $PID" 0 "kill terminateprocess"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
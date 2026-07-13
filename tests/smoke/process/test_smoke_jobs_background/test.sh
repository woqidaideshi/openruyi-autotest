#!/bin/bash
# Smoke test: process - jobs list background jobs
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeProcessSetup
 rlRun "sleep 1 &" 0 "Prepare environment"
 rlRun "wait" 0 "Prepare environment"

 rlPhaseEnd

 rlPhaseStartTest "jobs list background jobs"
 rlRun 'jobs' 0 "jobs list background jobs"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
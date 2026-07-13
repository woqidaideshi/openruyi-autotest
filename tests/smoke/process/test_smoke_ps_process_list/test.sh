#!/bin/bash
# Smoke test: process - ps currentprocess
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeProcessSetup

 rlPhaseEnd

 rlPhaseStartTest "ps currentprocess"
 rlRun 'ps' 0 "ps currentprocess"
 rlRun 'ps aux | head -5' 0 "ps aux allprocess"
 rlRun 'ps -p 1' 0 "ps viewPID 1"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
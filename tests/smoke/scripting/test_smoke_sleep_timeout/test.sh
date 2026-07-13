#!/bin/bash
# Smoke test: scripting - sleep 1seconds
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeScriptingSetup

 rlPhaseEnd

 rlPhaseStartTest "sleep 1seconds"
 rlRun 'sleep 1' 0 "sleep 1seconds"
 rlRun 'timeout 1 sleep 0.5' 0 "timeout command"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
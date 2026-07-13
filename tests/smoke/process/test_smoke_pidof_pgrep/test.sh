#!/bin/bash
# Smoke test: process - pidof searchsystemd
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeProcessSetup

 rlPhaseEnd

 rlPhaseStartTest "pidof searchsystemd"
 rlRun 'pidof systemd' 0 "pidof searchsystemd"
 rlRun 'pgrep -x systemd' 0 "pgrep searchprocess"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
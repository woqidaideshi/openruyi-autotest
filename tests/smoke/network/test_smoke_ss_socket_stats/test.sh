#!/bin/bash
# Smoke test: network - ss -tln listenTCPport
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ss -tln listenTCPport"
    rlRun 'ss -tln' 0 "ss -tln listenTCPport"
    rlRun 'ss -s' 0 "ss -s connectioncount"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
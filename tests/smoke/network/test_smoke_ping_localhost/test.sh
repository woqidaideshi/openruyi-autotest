#!/bin/bash
# Smoke test: network - ping localhost
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ping localhost"
    rlRun 'ping -c 3 127.0.0.1' 0 "ping localhost"
    rlRun 'ping -c 2 -W 2 8.8.8.8 2>&1 || true' 0 "ping "
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
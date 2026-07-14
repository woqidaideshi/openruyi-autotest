#!/bin/bash
# Smoke test: network - ssh version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ssh version"
    rlRun 'ssh -V 2>&1' 0 "ssh version"
    rlRun 'which scp' 0 "scp exists"
    rlRun 'which sftp' 0 "sftp exists"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
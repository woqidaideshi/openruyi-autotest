#!/bin/bash
# Smoke test: user_mgmt - sudo Command exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "sudo Command exists"
    rlRun 'which sudo' 0 "sudo Command exists"
    rlRun 'sudo -V 2>&1 | head -1' 0 "sudo version"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
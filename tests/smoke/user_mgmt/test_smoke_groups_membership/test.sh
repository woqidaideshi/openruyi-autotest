#!/bin/bash
# Smoke test: user_mgmt - groups currentusergroup
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeUserMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "groups currentusergroup"
    rlRun 'groups' 0 "groups currentusergroup"
    rlRun 'groups root' 0 "groups rootusergroup"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
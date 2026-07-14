#!/bin/bash
# Smoke test: permissions - passwd permissioncheck
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokePermissionsSetup

    rlPhaseEnd

    rlPhaseStartTest "passwd permissioncheck"
    rlRun 'ls -l /usr/bin/passwd' 0 "passwd permissioncheck"
    rlRun 'ls -l /usr/bin/sudo' 0 "sudo permissioncheck"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
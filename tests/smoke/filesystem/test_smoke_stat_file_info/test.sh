#!/bin/bash

# Smoke test: filesystem - stat file info

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeFSSetup

    rlPhaseEnd



    rlPhaseStartTest "stat viewfileinfo"

    rlRun "stat /etc/os-release" 0 "stat viewfile"

    rlRun "stat -c '%s' /etc/os-release" 0 "stat format-izeoutputsize"

    rlRun "stat /" 0 "stat viewdirectory"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
#!/bin/bash

# Smoke test: system_info - df disk usage

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeSystemInfoSetup



    rlPhaseEnd



    rlPhaseStartTest "df disk usage"

    rlRun 'df' 0 "df disk usage"

    rlRun 'df -h' 0 "df -h human-readable"

    rlRun 'df /' 0 "df rootpartition"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
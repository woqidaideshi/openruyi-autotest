#!/bin/bash

# Smoke test: system_info - date current time

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeSystemInfoSetup



    rlPhaseEnd



    rlPhaseStartTest "date current time"

    rlRun 'date' 0 "date current time"

    rlRun 'date +%Y-%m-%d' 0 "date format"

    rlRun 'date +%H:%M:%S' 0 "date format-izetime"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
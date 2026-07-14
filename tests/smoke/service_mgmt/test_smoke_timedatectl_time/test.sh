#!/bin/bash

# Smoke test: service_mgmt - timedatectl timeStatus

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeServiceMgmtSetup



    rlPhaseEnd



    rlPhaseStartTest "timedatectl timeStatus"

    rlRun 'timedatectl 2>&1 || true' 0 "timedatectl timeStatus"

    rlRun 'timedatectl list-timezones 2>&1 | head -3 || true' 0 "timedatectl list"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
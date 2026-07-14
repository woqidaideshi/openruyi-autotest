#!/bin/bash

# Smoke test: package_mgmt - rpm version

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokePackageMgmtSetup



    rlPhaseEnd



    rlPhaseStartTest "rpm version"

    rlRun 'rpm --version' 0 "rpm version"

    rlRun 'rpm -q coreutils' 0 "rpm -q "

    rlRun 'rpm -qa | head -5' 0 "rpm -qa listexportall"

    rlRun 'rpm -qi coreutils | head -5' 0 "rpm -qi info"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
#!/bin/bash

# Smoke test: package_mgmt - /etc/os-release exists

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokePackageMgmtSetup



    rlPhaseEnd



    rlPhaseStartTest "/etc/os-release exists"

    rlRun 'cat /etc/os-release' 0 "/etc/os-release exists"

    rlRun 'grep openRuyi /etc/os-release' 0 "openRuyi linesverconfirm"

    rlRun 'rpm -q openruyi-release' 0 "openruyi-release exists"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
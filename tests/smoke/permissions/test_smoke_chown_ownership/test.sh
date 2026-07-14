#!/bin/bash

# Smoke test: permissions - chown setall

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokePermissionsSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlRun "touch own.txt" 0 "Create test data"



    rlPhaseEnd



    rlPhaseStartTest "chown setall"

    rlRun 'chown $(whoami) own.txt' 0 "chown setall"

    rlRun 'test -O own.txt' 0 "fileincurrentuser"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
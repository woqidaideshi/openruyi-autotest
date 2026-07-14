#!/bin/bash

# Smoke test: security - umask current mask

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeSecuritySetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlRun "umask 022; touch umask_test" 0 "Create test data"



    rlPhaseEnd



    rlPhaseStartTest "umask current mask"

    rlRun 'umask' 0 "umask current mask"

    rlRun 'ls -l umask_test' 0 "umask newfilepermission"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
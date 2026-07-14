#!/bin/bash

# Functional test: wget - Continue-and-mirror

# Beakerlib-based test with lifecycle management

# Shared suite setup/cleanup via../lib.sh (install once, uninstall once)



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    wgetSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlPhaseEnd



    rlPhaseStartTest "Continue-and-mirror"

    rlRun "wget -c --version 2>&1 | grep -q Wget" 0 "wget -c breakpointOption exists"

    rlRun "wget -m --version 2>&1 | grep -q Wget" 0 "wget -m Option exists"

    rlRun "wget -N --version 2>&1 | grep -q Wget" 0 "wget -N timestampOption exists"

    rlPhaseEnd





    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    # wget Package managed by lib.sh's reference counting auto-uninstall

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd


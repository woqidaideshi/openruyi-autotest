#!/bin/bash

# Smoke test: shell_basics - *.txt wildcard

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeShellBasicsSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlRun "touch a.txt b.txt c.jpg" 0 "Create test data"



    rlPhaseEnd



    rlPhaseStartTest "*.txt wildcard"

    rlRun 'ls *.txt | wc -l' 0 "*.txt wildcard"

    rlRun 'ls ?.jpg' 0 "?.jpg singlewildcard"

    rlRun 'echo ~ | grep /' 0 "~ directoryat begin"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
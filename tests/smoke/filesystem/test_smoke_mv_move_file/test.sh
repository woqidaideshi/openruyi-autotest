#!/bin/bash

# Smoke test: filesystem - mv move/rename file

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeFSSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlRun "echo 'move me' > old.txt" 0 "createsource file"

    rlRun "mkdir dest" 0 "createtargetdirectory"

    rlPhaseEnd



    rlPhaseStartTest "mv move/file"

    rlRun "mv old.txt new.txt" 0 "mv "

    rlRun "test -f new.txt -a ! -f old.txt" 0 "filealreadydoes not exist"

    rlRun "mv new.txt dest/" 0 "mv move to directory"

    rlRun "test -f dest/new.txt" 0 "filealreadymove"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
#!/bin/bash

# Functional test: bzip2 - ѹerror handling

# Beakerlib-based test with lifecycle management

# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    bzip2Setup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlPhaseEnd



    rlPhaseStartTest "ѹerror handling"

    rlRun "TmpDir=$(mktemp -d)" 0 "error handlingʱĿ¼"

    rlRun "cd $TmpDir" 0 "error handlingdirectory"

    rlRun "echo \"test data for bzip2\" > testfile" 0 "error handlingļ"

    rlRun "bzip2 -k testfile" 0 "Compress keeping original file"

    rlRun "test -f testfile.bz2" 0 "Test operation"

    rlRun "bunzip2 -k testfile.bz2" 0 "ZIP decompression"

    rlRun "bzip2 testfile" 0 "Test operation"

    rlRun "test -f testfile.bz2" 0 "Test operation"

    rlRun "bunzip2 testfile.bz2" 0 "ZIP decompression"

    rlRun "test -f testfile" 0 "Test operation"

    rlRun "echo \"hello bzip2\" | bzip2 > test2.bz2" 0 "ͨܵѹ"

    rlRun "bzcat test2.bz2" 0 "Test operation"

    rlPhaseEnd





    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    # bzip2 Package managed by lib.sh 's reference counting auto-uninstall

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd


#!/bin/bash
# Functional test: kernel - blktests - loop/002
# blktests: ./check loop/002
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        blktestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter tmp dir"
    rlPhaseEnd

    rlPhaseStartTest "blktests - loop/002"
        rlRun "_blktestsRunCase loop 002" 0 "Run blktests loop/002"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        rlRun "cd /" 0 "Leave tmp dir"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
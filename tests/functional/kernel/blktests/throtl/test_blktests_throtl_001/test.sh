#!/bin/bash
# Functional test: kernel - blktests - throtl/001
# blktests: ./check throtl/001
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        blktestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter tmp dir"
    rlPhaseEnd

    rlPhaseStartTest "blktests - throtl/001"
        rlRun "_blktestsRunCase throtl 001" 0 "Run blktests throtl/001"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        rlRun "cd /" 0 "Leave tmp dir"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
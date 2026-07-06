#!/bin/bash
# Functional test: kernel - blktests - nvme/021
# blktests: ./check nvme/021
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        blktestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter tmp dir"
    rlPhaseEnd

    rlPhaseStartTest "blktests - nvme/021"
        rlRun "_blktestsRunCase nvme 021" 0 "Run blktests nvme/021"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        rlRun "cd /" 0 "Leave tmp dir"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
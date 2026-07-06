#!/bin/bash
# Functional test: kernel - blktests - nvme/060
# blktests: ./check nvme/060
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        blktestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter tmp dir"
    rlPhaseEnd

    rlPhaseStartTest "blktests - nvme/060"
        rlRun "_blktestsRunCase nvme 060" 0 "Run blktests nvme/060"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        rlRun "cd /" 0 "Leave tmp dir"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
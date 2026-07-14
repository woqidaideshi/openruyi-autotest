#!/bin/bash
# Functional test: kernel - mmtests - workload_stressng_class_io_parallel
# MMTests: run-mmtests.sh --config configs/config-workload-stressng-class-io-parallel
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    mmtestsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - workload_stressng_class_io_parallel"
    rlRun "_mmtestsRunCase config-workload-stressng-class-io-parallel" 0 "Execute MMTests config-workload-stressng-class-io-parallel"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
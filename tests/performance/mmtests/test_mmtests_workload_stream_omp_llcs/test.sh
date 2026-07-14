#!/bin/bash
# Functional test: kernel - mmtests - workload_stream_omp_llcs
# MMTests: run-mmtests.sh --config configs/config-workload-stream-omp-llcs
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    mmtestsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - workload_stream_omp_llcs"
    rlRun "_mmtestsRunCase config-workload-stream-omp-llcs" 0 "Execute MMTests config-workload-stream-omp-llcs"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
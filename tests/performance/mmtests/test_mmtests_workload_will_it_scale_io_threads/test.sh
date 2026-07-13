#!/bin/bash
# Functional test: kernel - mmtests - workload_will_it_scale_io_threads
# MMTests: run-mmtests.sh --config configs/config-workload-will-it-scale-io-threads
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 mmtestsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "MMTests - workload_will_it_scale_io_threads"
 rlRun "_mmtestsRunCase config-workload-will-it-scale-io-threads" 0 "Execute MMTests config-workload-will-it-scale-io-threads"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
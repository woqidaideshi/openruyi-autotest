#!/bin/bash
# Functional test: kernel - mmtests - scheduler_sysbench_cpu
# MMTests: run-mmtests.sh --config configs/config-scheduler-sysbench-cpu
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 mmtestsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "MMTests - scheduler_sysbench_cpu"
 rlRun "_mmtestsRunCase config-scheduler-sysbench-cpu" 0 "Execute MMTests config-scheduler-sysbench-cpu"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
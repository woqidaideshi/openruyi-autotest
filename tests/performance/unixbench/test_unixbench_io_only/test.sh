#!/bin/bash
# Performance test: UnixBench - UnixBench filesystem I/O test (fstime/fsbuffer/fsdisk)
# According to Testing-Guide.md Requirements:Execute three times, Average of all runs used as final score
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 unixbenchSetup
 rlRun "cd $UNIXBENCH_DIR/UnixBench" 0 "enter UnixBench directory"
 rlPhaseEnd

 rlPhaseStartTest "UnixBench filesystem I/O test (fstime/fsbuffer/fsdisk, 3independent runs)"
 if [ ! -f "$UNIXBENCH_DIR/UnixBench/Run" ]; then
 rlLogWarning "UnixBench not installed, skiptest"
 rlPhaseEnd
 rlJournalPrintText
 rlJournalEnd
 exit 0
 fi
 AVG=$(run_unixbench_3x "io_only" "-i 3 -c 1 fstime fsbuffer fsdisk")
 rlLogInfo "filesystem I/O 3 avg of runs System Benchmarks Index Score: $AVG"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
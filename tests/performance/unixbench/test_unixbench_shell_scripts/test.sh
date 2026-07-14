#!/bin/bash
# Performance test: UnixBench - UnixBench Shellscriptperformance (shell1 + shell8)
# According to Testing-Guide.md Requirements:Execute three times, Average of all runs used as final score
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    unixbenchSetup
    rlRun "cd $UNIXBENCH_DIR/UnixBench" 0 "enter UnixBench directory"
    rlPhaseEnd

    rlPhaseStartTest "UnixBench Shellscriptperformance (shell1 + shell8, 3independent runs)"
    if [ ! -f "$UNIXBENCH_DIR/UnixBench/Run" ]; then
    rlLogWarning "UnixBench not installed, skiptest"
    rlPhaseEnd
    rlJournalPrintText
    rlJournalEnd
    exit 0
    fi
    AVG=$(run_unixbench_3x "shell_scripts" "-i 3 -c 1 shell1 shell8")
    rlLogInfo "Shellscript 3 avg of runs System Benchmarks Index Score: $AVG"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
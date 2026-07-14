#!/bin/bash
# Compatibility test: LTP POSIX - sched/sched_get_priority_max
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    ltpPosixSetup
    rlPhaseEnd

    rlPhaseStartTest "POSIX Interface: sched / sched_get_priority_max"
    rlRun "run_posix_iface_test 'sched_get_priority_max'" 0 "sched/sched_get_priority_max Interface conformance test"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
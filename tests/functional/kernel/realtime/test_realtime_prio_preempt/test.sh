#!/bin/bash
# Functional test: kernel - realtime - prio-preempt
# LTP Realtime: run.sh -t func/prio-preempt
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    realtimeSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "LTP Realtime - prio-preempt"
    rlRun "_realtimeRunCase prio-preempt" 0 "Execute LTP Realtime prio-preempt"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
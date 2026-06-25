#!/bin/bash
# Smoke test: process - kill signal
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeProcessSetup
        rlRun "sleep 10 &" 0 "准备环境"
        rlRun "PID=$!" 0 "准备环境"
        rlRun "sleep 1" 0 "准备环境"
        rlRun "if kill -0 $PID 2>/dev/null; then" 0 "准备环境"
        rlRun "echo "kill may not have worked"" 0 "准备环境"
        rlRun "fi" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "kill signal"
        rlRun "kill $PID" 0 "kill 终止进程"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
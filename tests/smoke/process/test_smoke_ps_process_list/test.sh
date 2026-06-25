#!/bin/bash
# Smoke test: process - ps 当前进程
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeProcessSetup

    rlPhaseEnd

    rlPhaseStartTest "ps 当前进程"
        rlRun 'ps' 0 "ps 当前进程"
        rlRun 'ps aux | head -5' 0 "ps aux 全部进程"
        rlRun 'ps -p 1' 0 "ps 查看PID 1"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
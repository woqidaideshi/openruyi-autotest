#!/bin/bash
# Smoke test: process - jobs 列出后台任务
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeProcessSetup
        rlRun "sleep 1 &" 0 "准备环境"
        rlRun "wait" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "jobs 列出后台任务"
        rlRun 'jobs' 0 "jobs 列出后台任务"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
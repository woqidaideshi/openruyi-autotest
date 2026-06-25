#!/bin/bash
# Smoke test: system_info - date 当前时间
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "date 当前时间"
        rlRun 'date' 0 "date 当前时间"
        rlRun 'date +%Y-%m-%d' 0 "date 格式化日期"
        rlRun 'date +%H:%M:%S' 0 "date 格式化时间"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
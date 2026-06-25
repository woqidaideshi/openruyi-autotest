#!/bin/bash
# Smoke test: system_info - free 内存使用
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "free 内存使用"
        rlRun 'free' 0 "free 内存使用"
        rlRun 'free -h' 0 "free -h 人类可读"
        rlRun 'free -t' 0 "free -t 含合计行"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
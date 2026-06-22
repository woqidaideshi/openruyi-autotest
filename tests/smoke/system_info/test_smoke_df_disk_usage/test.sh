#!/bin/bash
# Smoke test: system_info - df 磁盘使用
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "df 磁盘使用"
        rlRun 'df' 0 "df 磁盘使用"
        rlRun 'df -h' 0 "df -h 人类可读"
        rlRun 'df /' 0 "df 根分区"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
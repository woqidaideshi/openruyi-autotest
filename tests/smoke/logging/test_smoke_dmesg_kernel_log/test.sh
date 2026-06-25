#!/bin/bash
# Smoke test: logging - dmesg 内核日志
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeLoggingSetup

    rlPhaseEnd

    rlPhaseStartTest "dmesg 内核日志"
        rlRun 'dmesg | head -10' 0 "dmesg 内核日志"
        rlRun 'dmesg | wc -l' 0 "dmesg 日志行数"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
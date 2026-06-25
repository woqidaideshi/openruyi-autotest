#!/bin/bash
# Smoke test: logging - logger 写入日志
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeLoggingSetup

    rlPhaseEnd

    rlPhaseStartTest "logger 写入日志"
        rlRun 'logger -t smoke_test "smoke test log message"' 0 "logger 写入日志"
        rlRun 'journalctl -t smoke_test --no-pager -n 1 2>&1 || true' 0 "journalctl 查询测试日志"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
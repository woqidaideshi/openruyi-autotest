#!/bin/bash
# Smoke test: service_mgmt - journalctl 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeServiceMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "journalctl 版本"
        rlRun 'journalctl --version' 0 "journalctl 版本"
        rlRun 'journalctl -n 10 --no-pager 2>&1 || true' 0 "journalctl 最近日志"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
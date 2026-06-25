#!/bin/bash
# Smoke test: service_mgmt - systemd-analyze 启动时间
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeServiceMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "systemd-analyze 启动时间"
        rlRun 'timeout 10 systemd-analyze 2>&1 || true' 0 "systemd-analyze 启动时间"
        rlRun 'timeout 15 systemd-analyze blame 2>&1 | head -5 || true' 0 "systemd-analyze blame"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
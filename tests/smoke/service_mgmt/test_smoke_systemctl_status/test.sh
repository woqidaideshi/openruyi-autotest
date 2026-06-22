#!/bin/bash
# Smoke test: service_mgmt - systemctl 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeServiceMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "systemctl 版本"
        rlRun 'systemctl --version' 0 "systemctl 版本"
        rlRun 'systemctl list-units --type=service | head -5' 0 "systemctl 服务列表"
        rlRun 'systemctl is-system-running 2>&1 || true' 0 "systemctl 系统运行状态"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
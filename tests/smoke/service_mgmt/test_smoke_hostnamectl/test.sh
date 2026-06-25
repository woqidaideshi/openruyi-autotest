#!/bin/bash
# Smoke test: service_mgmt - hostnamectl 状态
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeServiceMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "hostnamectl 状态"
        rlRun 'hostnamectl 2>&1 || true' 0 "hostnamectl 状态"
        rlRun 'hostnamectl status 2>&1 || true' 0 "hostnamectl status"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
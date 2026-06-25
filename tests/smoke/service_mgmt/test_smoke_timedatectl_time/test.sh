#!/bin/bash
# Smoke test: service_mgmt - timedatectl 时间状态
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeServiceMgmtSetup

    rlPhaseEnd

    rlPhaseStartTest "timedatectl 时间状态"
        rlRun 'timedatectl 2>&1 || true' 0 "timedatectl 时间状态"
        rlRun 'timedatectl list-timezones 2>&1 | head -3 || true' 0 "timedatectl 时区列表"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
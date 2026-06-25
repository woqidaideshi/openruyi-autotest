#!/bin/bash
# Smoke test: network - ss -tln 监听TCP端口
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ss -tln 监听TCP端口"
        rlRun 'ss -tln' 0 "ss -tln 监听TCP端口"
        rlRun 'ss -s' 0 "ss -s 连接统计"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
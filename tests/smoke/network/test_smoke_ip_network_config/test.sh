#!/bin/bash
# Smoke test: network - ip addr 网络接口
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ip addr 网络接口"
        rlRun 'ip addr show' 0 "ip addr 网络接口"
        rlRun 'ip link show' 0 "ip link 链路层"
        rlRun 'ip route show' 0 "ip route 路由表"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
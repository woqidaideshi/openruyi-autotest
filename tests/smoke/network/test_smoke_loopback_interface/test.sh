#!/bin/bash
# Smoke test: network - lo 回环接口存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "lo 回环接口存在"
        rlRun 'ip addr show lo | grep -q LOOPBACK' 0 "lo 回环接口存在"
        rlRun 'ping -c 1 127.0.0.1' 0 "127.0.0.1 可ping"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
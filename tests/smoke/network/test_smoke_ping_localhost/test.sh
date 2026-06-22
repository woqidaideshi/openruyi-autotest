#!/bin/bash
# Smoke test: network - ping localhost
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ping localhost"
        rlRun 'ping -c 3 127.0.0.1' 0 "ping localhost"
        rlRun 'ping -c 2 -W 2 8.8.8.8 2>&1 || true' 0 "ping 外部地址"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
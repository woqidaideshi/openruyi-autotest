#!/bin/bash
# Smoke test: network - getent 解析 localhost
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "getent 解析 localhost"
        rlRun 'getent hosts localhost' 0 "getent 解析 localhost"
        rlRun 'cat /etc/resolv.conf' 0 "/etc/resolv.conf DNS配置"
        rlRun 'cat /etc/hosts' 0 "/etc/hosts 本地解析"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
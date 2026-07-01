#!/bin/bash
# Functional test: kernel - mmtests - network_iperf_ipv6_unbound
# MMTests: run-mmtests.sh --config configs/config-network-iperf-ipv6-unbound
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        mmtestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - network_iperf_ipv6_unbound"
        rlRun "_mmtestsRunCase config-network-iperf-ipv6-unbound" 0 "执行 MMTests config-network-iperf-ipv6-unbound"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
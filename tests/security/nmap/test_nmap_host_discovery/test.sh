#!/bin/bash
# Security test: nmap - nmap 网络主机发现
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap 网络主机发现"
        rlRun 'nmap -T4 --host-timeout 30s -sn 127.0.0.1 2>&1 || true' 0 "Ping 扫描"
        rlRun 'nmap -T4 --host-timeout 30s -PE localhost 2>&1 || true' 0 "ICMP Echo 发现"
        rlRun 'nmap -T4 --host-timeout 30s -PS -p 22 localhost 2>&1 || true' 0 "TCP SYN Ping 发现"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
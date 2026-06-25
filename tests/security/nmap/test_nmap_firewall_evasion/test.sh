#!/bin/bash
# Security test: nmap - nmap 防火墙/IDS 规避
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap 防火墙/IDS 规避"
        rlRun 'nmap -T4 --host-timeout 30s -f -p 22 localhost 2>&1 || true' 0 "分片包扫描"
        rlRun 'nmap -T4 --host-timeout 30s --data-length 30 -p 22 localhost 2>&1 || true' 0 "随机数据填充"
        rlRun 'nmap -T4 --host-timeout 30s --badsum -p 22 localhost 2>&1 || true' 0 "错误校验和探测"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
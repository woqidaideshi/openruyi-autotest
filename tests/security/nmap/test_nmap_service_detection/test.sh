#!/bin/bash
# Security test: nmap - nmap 服务版本检测
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap 服务版本检测"
        rlRun 'nmap --version 2>&1' 0 "获取 nmap 版本"
        rlRun 'OPEN_PORTS=$(nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>/dev/null | awk '/open/ {print $1}' | cut -d/ -f1 | tr '\n' ' ' || true)' 0 "检测开放端口"
        rlRun 'for port in $OPEN_PORTS; do nmap -T4 --host-timeout 30s -sV -p $port localhost 2>&1; done || true' 0 "服务版本检测"
        rlRun 'nmap -T4 --host-timeout 30s -sV --version-intensity 3 -p ${OPEN_PORTS%% *} localhost 2>&1 || true' 0 "高强度版本探测"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
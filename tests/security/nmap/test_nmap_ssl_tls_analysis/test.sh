#!/bin/bash
# Security test: nmap - nmap SSL/TLS 安全分析
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap SSL/TLS 安全分析"
        rlRun 'nmap --version 2>&1' 0 "获取 nmap 版本"
        rlRun 'nmap -T4 --host-timeout 30s --script=ssl-cert -p 443 localhost 2>&1' 0 "SSL 证书分析"
        rlRun 'nmap -T4 --host-timeout 30s --script=ssl-heartbleed -p 443 localhost 2>&1' 0 "Heartbleed 漏洞检测"
        rlRun 'nmap -T4 --host-timeout 30s --script=sslv2 -p 443 localhost 2>&1' 0 "SSLv2 支持检测"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
#!/bin/bash
# Security test: nmap - nmap TCP/UDP 端口扫描
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap TCP/UDP 端口扫描"
        rlRun 'nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>&1' 0 "TCP 端口扫描 (常用端口)"
        rlRun 'nmap -T4 --host-timeout 30s -sU -p 53 localhost 2>&1' 0 "UDP 端口扫描 (DNS)"
        rlRun 'nmap -T4 --host-timeout 30s -p 1-100 localhost 2>&1' 0 "TCP 端口扫描 (1-100)"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
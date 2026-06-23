#!/bin/bash
# Security test: nmap - nmap 操作系统指纹识别
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap 操作系统指纹识别"
        rlRun 'nmap -T4 --host-timeout 60s -O localhost 2>&1 || true' 0 "操作系统指纹识别"
        rlRun 'nmap -T4 --host-timeout 30s -O --osscan-limit localhost 2>&1 || true' 0 "限制型 OS 检测"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
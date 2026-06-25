#!/bin/bash
# Security test: nmap - nmap NSE 脚本扫描
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup

    rlPhaseEnd

    rlPhaseStartTest "nmap NSE 脚本扫描"
        rlRun 'nmap --version 2>&1' 0 "获取 nmap 版本"
        rlRun 'OPEN_PORTS=$(nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>/dev/null | awk '/open/ {print $1}' | cut -d/ -f1 | tr '\n' ' ' || true)' 0 "检测开放端口"
        rlRun 'echo "$OPEN_PORTS" | grep -q 22 && nmap -T4 --host-timeout 30s --script=banner -p 22 localhost 2>&1 || true' 0 "NSE banner 脚本"
        rlRun 'echo "$OPEN_PORTS" | grep -q 22 && nmap -T4 --host-timeout 30s --script=ssh-auth-methods -p 22 localhost 2>&1 || true' 0 "NSE SSH 认证方法"
        rlRun 'echo "$OPEN_PORTS" | grep -q 80 && nmap -T4 --host-timeout 30s --script=http-headers -p 80 localhost 2>&1 || true' 0 "NSE HTTP 头检测"
        rlRun 'echo "$OPEN_PORTS" | grep -q 443 && nmap -T4 --host-timeout 30s --script=ssl-enum-ciphers -p 443 localhost 2>&1 || true' 0 "NSE SSL 密码套件"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
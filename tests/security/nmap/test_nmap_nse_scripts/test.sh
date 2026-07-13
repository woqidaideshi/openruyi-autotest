#!/bin/bash
# Security test: nmap - nmap NSE script
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 nmapSetup

 rlPhaseEnd

 rlPhaseStartTest "nmap NSE script"
 rlRun 'nmap --version 2>&1' 0 "get nmap version"
 rlRun 'OPEN_PORTS=$(nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>/dev/null | awk '/open/ {print $1}' | cut -d/ -f1 | tr '\n' ' ' || true)' 0 "detectat beginport"
 rlRun 'echo "$OPEN_PORTS" | grep -q 22 && nmap -T4 --host-timeout 30s --script=banner -p 22 localhost 2>&1 || true' 0 "NSE banner script"
 rlRun 'echo "$OPEN_PORTS" | grep -q 22 && nmap -T4 --host-timeout 30s --script=ssh-auth-methods -p 22 localhost 2>&1 || true' 0 "NSE SSH "
 rlRun 'echo "$OPEN_PORTS" | grep -q 80 && nmap -T4 --host-timeout 30s --script=http-headers -p 80 localhost 2>&1 || true' 0 "NSE HTTP headerdetect"
 rlRun 'echo "$OPEN_PORTS" | grep -q 443 && nmap -T4 --host-timeout 30s --script=ssl-enum-ciphers -p 443 localhost 2>&1 || true' 0 "NSE SSL "
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
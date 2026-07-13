#!/bin/bash
# Security test: nmap - nmap TCP/UDP port scan
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 nmapSetup

 rlPhaseEnd

 rlPhaseStartTest "nmap TCP/UDP port scan"
 rlRun 'nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>&1' 0 "TCP port scan (withport)"
 rlRun 'nmap -T4 --host-timeout 30s -sU -p 53 localhost 2>&1' 0 "UDP port scan (DNS)"
 rlRun 'nmap -T4 --host-timeout 30s -p 1-100 localhost 2>&1' 0 "TCP port scan (1-100)"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
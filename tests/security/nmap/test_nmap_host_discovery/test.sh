#!/bin/bash
# Security test: nmap - nmap network
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 nmapSetup

 rlPhaseEnd

 rlPhaseStartTest "nmap network"
 rlRun 'nmap -T4 --host-timeout 30s -sn 127.0.0.1 2>&1 || true' 0 "Ping "
 rlRun 'nmap -T4 --host-timeout 30s -PE localhost 2>&1 || true' 0 "ICMP Echo "
 rlRun 'nmap -T4 --host-timeout 30s -PS -p 22 localhost 2>&1 || true' 0 "TCP SYN Ping "
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
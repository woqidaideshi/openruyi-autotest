#!/bin/bash
# Security test: nmap - nmap /IDS 
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 nmapSetup

 rlPhaseEnd

 rlPhaseStartTest "nmap /IDS "
 rlRun 'nmap -T4 --host-timeout 30s -f -p 22 localhost 2>&1 || true' 0 ""
 rlRun 'nmap -T4 --host-timeout 30s --data-length 30 -p 22 localhost 2>&1 || true' 0 "randomdata"
 rlRun 'nmap -T4 --host-timeout 30s --badsum -p 22 localhost 2>&1 || true' 0 "errorchecksumand"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
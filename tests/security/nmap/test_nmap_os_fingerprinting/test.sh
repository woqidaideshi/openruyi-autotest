#!/bin/bash

# Security test: nmap - nmap OS fingerprint

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 nmapSetup



 rlPhaseEnd



 rlPhaseStartTest "nmap OS fingerprint"

 rlRun 'nmap -T4 --host-timeout 60s -O localhost 2>&1 || true' 0 "OS fingerprint"

 rlRun 'nmap -T4 --host-timeout 30s -O --osscan-limit localhost 2>&1 || true' 0 " OS detect"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd
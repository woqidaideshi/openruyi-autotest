#!/bin/bash

# Security test: nmap - nmap serviceversiondetect

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 nmapSetup



 rlPhaseEnd



 rlPhaseStartTest "nmap serviceversiondetect"

 rlRun 'nmap --version 2>&1' 0 "get nmap version"

 rlRun 'OPEN_PORTS=$(nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>/dev/null | awk '/open/ {print $1}' | cut -d/ -f1 | tr '\n' ' ' || true)' 0 "detectat beginport"

 rlRun 'for port in $OPEN_PORTS; do nmap -T4 --host-timeout 30s -sV -p $port localhost 2>&1; done || true' 0 "serviceversiondetect"

 rlRun 'nmap -T4 --host-timeout 30s -sV --version-intensity 3 -p ${OPEN_PORTS%% *} localhost 2>&1 || true' 0 "version"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd
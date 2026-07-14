#!/bin/bash

# Security test: nmap - nmap SSL/TLS securityanalysis

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    nmapSetup



    rlPhaseEnd



    rlPhaseStartTest "nmap SSL/TLS securityanalysis"

    rlRun 'nmap --version 2>&1' 0 "get nmap version"

    rlRun 'nmap -T4 --host-timeout 30s --script=ssl-cert -p 443 localhost 2>&1' 0 "SSL certificateanalysis"

    rlRun 'nmap -T4 --host-timeout 30s --script=ssl-heartbleed -p 443 localhost 2>&1' 0 "Heartbleed detect"

    rlRun 'nmap -T4 --host-timeout 30s --script=sslv2 -p 443 localhost 2>&1' 0 "SSLv2 supportsdetect"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd
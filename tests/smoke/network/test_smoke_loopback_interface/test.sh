#!/bin/bash
# Smoke test: network - lo loopbackInterfaceexists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeNetworkSetup

 rlPhaseEnd

 rlPhaseStartTest "lo loopbackInterfaceexists"
 rlRun 'ip addr show lo | grep -q LOOPBACK' 0 "lo loopbackInterfaceexists"
 rlRun 'ping -c 1 127.0.0.1' 0 "127.0.0.1 canping"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
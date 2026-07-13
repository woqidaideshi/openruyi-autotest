#!/bin/bash
# Smoke test: network - ip addr networkInterface
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeNetworkSetup

 rlPhaseEnd

 rlPhaseStartTest "ip addr networkInterface"
 rlRun 'ip addr show' 0 "ip addr networkInterface"
 rlRun 'ip link show' 0 "ip link "
 rlRun 'ip route show' 0 "ip route bytable"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
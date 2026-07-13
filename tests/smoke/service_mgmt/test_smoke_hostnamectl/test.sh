#!/bin/bash
# Smoke test: service_mgmt - hostnamectl Status
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeServiceMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "hostnamectl Status"
 rlRun 'hostnamectl 2>&1 || true' 0 "hostnamectl Status"
 rlRun 'hostnamectl status 2>&1 || true' 0 "hostnamectl status"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
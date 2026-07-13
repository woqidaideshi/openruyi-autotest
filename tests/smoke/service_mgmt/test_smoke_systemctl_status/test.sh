#!/bin/bash
# Smoke test: service_mgmt - systemctl version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeServiceMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "systemctl version"
 rlRun 'systemctl --version' 0 "systemctl version"
 rlRun 'systemctl list-units --type=service | head -5' 0 "systemctl servicelist"
 rlRun 'systemctl is-system-running 2>&1 || true' 0 "systemctl systemrunStatus"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
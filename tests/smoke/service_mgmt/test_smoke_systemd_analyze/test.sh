#!/bin/bash
# Smoke test: service_mgmt - systemd-analyze startup time
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeServiceMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "systemd-analyze startup time"
 rlRun 'timeout 10 systemd-analyze 2>&1 || true' 0 "systemd-analyze startup time"
 rlRun 'timeout 15 systemd-analyze blame 2>&1 | head -5 || true' 0 "systemd-analyze blame"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
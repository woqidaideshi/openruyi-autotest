#!/bin/bash
# Smoke test: service_mgmt - journalctl version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeServiceMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "journalctl version"
 rlRun 'journalctl --version' 0 "journalctl version"
 rlRun 'journalctl -n 10 --no-pager 2>&1 || true' 0 "journalctl log"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
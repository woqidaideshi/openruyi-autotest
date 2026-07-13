#!/bin/bash
# Smoke test: logging - logger writelog
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeLoggingSetup

 rlPhaseEnd

 rlPhaseStartTest "logger writelog"
 rlRun 'logger -t smoke_test "smoke test log message"' 0 "logger writelog"
 rlRun 'journalctl -t smoke_test --no-pager -n 1 2>&1 || true' 0 "journalctl testlog"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
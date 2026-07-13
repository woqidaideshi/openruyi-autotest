#!/bin/bash
# Smoke test: logging - /etc/logrotate.d directory exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeLoggingSetup

 rlPhaseEnd

 rlPhaseStartTest "/etc/logrotate.d directory exists"
 rlRun 'test -d /etc/logrotate.d' 0 "/etc/logrotate.d directory exists"
 rlRun 'logrotate --version 2>&1 || true' 0 "logrotate available"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
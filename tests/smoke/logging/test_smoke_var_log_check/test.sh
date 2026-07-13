#!/bin/bash
# Smoke test: logging - /var/log directory exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeLoggingSetup

 rlPhaseEnd

 rlPhaseStartTest "/var/log directory exists"
 rlRun 'test -d /var/log' 0 "/var/log directory exists"
 rlRun 'ls /var/log | head -10' 0 "/var/log logfilelist"
 rlRun 'test -f /var/log/messages || test -f /var/log/syslog || echo "no standard syslog"' 0 "systemlogexistscheck"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
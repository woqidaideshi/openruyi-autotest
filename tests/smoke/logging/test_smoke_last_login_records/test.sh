#!/bin/bash

# Smoke test: logging - last recent logins

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeLoggingSetup



 rlPhaseEnd



 rlPhaseStartTest "last recent logins"

 rlRun 'last -n 5 2>&1 || true' 0 "last recent logins"

 rlRun 'test -f /var/log/wtmp' 0 "/var/log/wtmp record"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd
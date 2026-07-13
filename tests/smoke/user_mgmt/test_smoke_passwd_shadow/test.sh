#!/bin/bash
# Smoke test: user_mgmt - /etc/passwd file exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeUserMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "/etc/passwd file exists"
 rlRun 'test -f /etc/passwd' 0 "/etc/passwd file exists"
 rlRun 'test -f /etc/shadow' 0 "/etc/shadow file exists"
 rlRun 'cat /etc/passwd | head -3' 0 "/etc/passwd readable"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
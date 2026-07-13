#!/bin/bash
# Smoke test: user_mgmt - /etc/skel directory exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeUserMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "/etc/skel directory exists"
 rlRun 'test -d /etc/skel' 0 "/etc/skel directory exists"
 rlRun 'ls -la /home' 0 "ls /home userdirectory"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
#!/bin/bash
# Smoke test: user_mgmt - whoami currentuser
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeUserMgmtSetup

 rlPhaseEnd

 rlPhaseStartTest "whoami currentuser"
 rlRun 'whoami' 0 "whoami currentuser"
 rlRun 'id' 0 "id userandgroupinfo"
 rlRun 'id -u' 0 "id -u UID"
 rlRun 'id -g' 0 "id -g GID"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
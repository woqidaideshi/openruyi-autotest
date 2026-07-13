#!/bin/bash
# Smoke test: permissions - /tmp directory exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokePermissionsSetup

 rlPhaseEnd

 rlPhaseStartTest "/tmp directory exists"
 rlRun 'test -d /tmp' 0 "/tmp directory exists"
 rlRun 'ls -ld /tmp' 0 "ls -ld /tmp permission"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
#!/bin/bash
# Functional test: ltp - hugetlb - hugeshmget02
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 ltpSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "LTP hugetlb - hugeshmget02"
 rlRun "_ltpRunCase hugetlb hugeshmget02" 0 "Execute LTP hugeshmget02"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
 # LTP Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

#!/bin/bash
# Functional test: ltp - syscalls - mknod06
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

 rlPhaseStartTest "LTP syscalls - mknod06"
 rlRun "_ltpRunCase syscalls mknod06" 0 "Execute LTP mknod06"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
 # LTP Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

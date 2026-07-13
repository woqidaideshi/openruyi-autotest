#!/bin/bash
# Functional test: ltp - syscalls - setpgid01
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

 rlPhaseStartTest "LTP syscalls - setpgid01"
 rlRun "_ltpRunCase syscalls setpgid01" 0 "Execute LTP setpgid01"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Cleanup"
 # LTP Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

#!/bin/bash
# Functional test: wget - Timeout-and-retries
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 wgetSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Timeout-and-retries"
 rlRun "wget --timeout=1 --version 2>&1 | grep -q Wget" 0 "wget --timeout Option exists"
 rlRun "wget --connect-timeout=1 --version 2>&1 | grep -q Wget" 0 "wget --connect-timeout Option exists"
 rlRun "wget --dns-timeout=1 --version 2>&1 | grep -q Wget" 0 "wget --dns-timeout Option exists"
 rlRun "wget --tries=1 --version 2>&1 | grep -q Wget" 0 "wget --tries Option exists"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # wget Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

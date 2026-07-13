#!/bin/bash
# Functional test: wget - Special-features
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

 rlPhaseStartTest "Special-features"
 rlRun "wget --post-data='test' --version 2>&1 | grep -q Wget" 0 "wget --post-data Option exists"
 rlRun "wget --body-data='test' --version 2>&1 | grep -q Wget" 0 "wget --body-data Option exists"
 rlRun "wget --content-on-error --version 2>&1 | grep -q Wget" 0 "wget --content-on-error option"
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

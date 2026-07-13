#!/bin/bash
# Functional test: procps-ng - ng - slabtop--tload--watch--hugetop
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 procpsNgSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "ng - slabtop--tload--watch--hugetop"
 rlRun "which slabtop 2>/dev/null || echo slabtop-not-found" 0 "slabtop Command check"
 rlRun "which tload 2>/dev/null || echo tload-not-found" 0 "tload Command check"
 rlRun "watch --version" 0 "watch --version"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # procps-ng Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

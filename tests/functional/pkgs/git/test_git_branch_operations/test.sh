#!/bin/bash
# Functional test: git - Branch-operations
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 gitSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "Branch-operations"
 rlRun "git branch feature" 0 "git branch: create branch"
 rlRun "git branch" 0 "git branch: list branches"
 rlRun "git branch -a" 0 "git branch -a: all branches"
 rlRun "git switch feature" 0 "git switch: switch branch"
 rlRun "git switch -" 0 "git switch -: previous branch"
 rlRun "git branch -d feature" 0 "git branch -d: delete branch"
 rlPhaseEnd


 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 # git Package managed by lib.sh 's reference counting auto-uninstall
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd

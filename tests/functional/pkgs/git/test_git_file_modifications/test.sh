#!/bin/bash
# Functional test: git - File-modifications
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

 rlPhaseStartTest "File-modifications"
 rlRun "git add file2.txt" 0 "git add: second file"
 rlRun "git commit -m \"add file2\"" 0 "git commit: second commit"
 rlRun "git diff" 0 "git diff: show changes"
 rlRun "git diff --cached" 0 "git diff --cached: staged changes"
 rlRun "git add file1.txt && git commit -m \"modify file1\"" 0 "git commit: modify"
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

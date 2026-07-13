#!/bin/bash
# Smoke test: filesystem - mkdir/rmdir directory operations
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeFSSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlPhaseEnd

 rlPhaseStartTest "mkdir/rmdir createdeletedirectory"
 rlRun "mkdir newdir" 0 "mkdir Create directory"
 rlRun "test -d newdir" 0 "directory exists"
 rlRun "mkdir -p a/b/c" 0 "mkdir -p createnesteddirectory"
 rlRun "test -d a/b/c" 0 "nesteddirectory exists"
 rlRun "rmdir newdir" 0 "rmdir deletedirectory"
 rlRun "mkdir nonempty" 0 "createnon-directory"
 rlRun "touch nonempty/f" 0 "Create directoryfile"
 rlRun "rm -rf nonempty" 0 "rm -rf deletenon-directory"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
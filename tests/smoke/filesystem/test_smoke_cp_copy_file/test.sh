#!/bin/bash
# Smoke test: filesystem - cp copy file and directory
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeFSSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "echo 'data' > src.txt" 0 "createsource file"
 rlRun "mkdir sub" 0 "createsourcedirectory"
 rlRun "echo 'nested' > sub/f.txt" 0 "createsubfile"
 rlPhaseEnd

 rlPhaseStartTest "cp copyfileanddirectory"
 rlRun "cp src.txt dst.txt" 0 "cp copyfile"
 rlRun "diff src.txt dst.txt" 0 "verifycopyconsistent"
 rlRun "cp -r sub sub2" 0 "cp -r recursivecopydirectory"
 rlRun "test -f sub2/f.txt" 0 "subdirectoryfile exists"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
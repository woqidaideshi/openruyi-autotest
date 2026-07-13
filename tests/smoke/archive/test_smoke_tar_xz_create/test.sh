#!/bin/bash
# Smoke test: archive - tar -cJf createtar.xz
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeArchiveSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 rlRun "mkdir data" 0 "createdatadirectory"
 rlRun "echo content > data/file.txt" 0 "Create test file"

 rlPhaseEnd

 rlPhaseStartTest "tar -cJf createtar.xz"
 rlRun 'tar -cJf data.tar.xz data' 0 "tar -cJf createtar.xz"
 rlRun 'test -f data.tar.xz' 0 "tar.xz file exists"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
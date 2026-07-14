#!/bin/bash

# Functional test: cmake - CMake--E-mode

# Beakerlib-based test with lifecycle management

# Shared suite setup/cleanup via../lib.sh (install once, uninstall once)



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 cmakeSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 rlPhaseEnd



 rlPhaseStartTest "CMake--E-mode"

 rlRun "cmake -E echo 'hello'" 0 "cmake -E echo output"

 rlRun "cmake -E make_directory $TmpDir/testdir" 0 "cmake -E make_directory Create directory"

 rlRun "test -d $TmpDir/testdir" 0 "verifydirectoryalreadycreate"

 rlRun "cmake -E touch $TmpDir/testdir/test.txt" 0 "cmake -E touch createfile"

 rlRun "test -f $TmpDir/testdir/test.txt" 0 "verifyfilealreadycreate"

 rlRun "cmake -E copy $TmpDir/testdir/test.txt $TmpDir/testdir/test2.txt" 0 "cmake -E copy copyfile"

 rlRun "test -f $TmpDir/testdir/test2.txt" 0 "verifyalreadycreate"

 rlRun "cmake -E remove $TmpDir/testdir/test2.txt" 0 "cmake -E remove deletefile"

 rlRun "cmake -E remove_directory $TmpDir/testdir" 0 "cmake -E remove_directory deletedirectory"

 rlRun "cmake -E environment 2>&1 | grep -q PATH" 0 "cmake -E environment displayenvironment variables"

 rlPhaseEnd





 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 # cmake Package managed by lib.sh's reference counting auto-uninstall

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd


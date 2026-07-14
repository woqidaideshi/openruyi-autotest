#!/bin/bash

# Functional test: cmake - CMake-configure

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



 rlPhaseStartTest "CMake-configure"

 rlRun "echo 'cmake_minimum_required(VERSION 3.10)' > $TmpDir/CMakeLists.txt" 0 "Create minimal CMakeLists.txt"

 rlRun "echo 'project(ConfigTest)' >> $TmpDir/CMakeLists.txt" 0 "declareditems"

 rlRun "cmake -S $TmpDir -B $TmpDir/build1 -D CMAKE_BUILD_TYPE=Release" 0 "cmake configuration Release build"

 rlRun "grep -q CMAKE_BUILD_TYPE:STRING=Release $TmpDir/build1/CMakeCache.txt" 0 "verify Release configurationalreadyset"

 rlRun "cmake -S $TmpDir -B $TmpDir/build2 -D CMAKE_C_COMPILER=$(which gcc)" 0 "cmake specify C compile"

 rlRun "test -f $TmpDir/build2/CMakeCache.txt" 0 "verify#configurationsuccess"

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


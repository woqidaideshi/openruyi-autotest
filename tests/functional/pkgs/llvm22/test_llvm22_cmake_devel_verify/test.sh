#!/bin/bash

# Functional test: llvm22-devel - cmake exportfullverify

# verify llvm22-devel package provides.cmake filereferenceallfilewhetheractuallyexists

# vsshould issue: https://github.com/openRuyi-Project/openRuyi/issues/760

# issue: LLVMExports.cmake referencedoes not exist.a file (e.g. libLLVMTestingAnnotations.a)

# causes find_package(LLVM) inconfigurationstage willfailed

#

# verifymethod:

# find_package(LLVM) → LLVMConfig.cmake → LLVMExports.cmake

# LLVMExports.cmake is the onlyone columnexportall target→filemappingfile, 

# When loading it checkschecksumeach target reference.a/.so whetheractuallyexists.

# other.cmake file (AddLLVM, CheckAtomic)isInternalbuildauxiliarymodule, 

# noin find_package loaded at time, andnocontainsfilepathreference, 

# nowillproduced issue#760 typeissue, noneedsinglealoneverify.



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 llvm22Setup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"



 # auto-discover LLVM cmake directory

 LLVM_CMAKE_DIR=$(rpm -ql llvm22-devel | grep 'LLVMConfig\.cmake$' | head -1 | xargs dirname)

 rlLogInfo "LLVM cmake directory: $LLVM_CMAKE_DIR"



 # count.cmake filecount

 CMAKE_COUNT=$(rpm -ql llvm22-devel | grep -c '\.cmake$')

 rlLogInfo "llvm22-devel $CMAKE_COUNT.cmake file"

 rlPhaseEnd



 rlPhaseStartTest "find_package(LLVM) COMPONENTS - checksum LLVMExports.cmake exportfull"

 if [ "$CMAKE_COUNT" -eq 0 ]; then

 rlLogWarning "llvm22-devel not.cmake file, skip cmake checksum"

 else

 cat > "$TmpDir/CMakeLists.txt" << 'CMAKEEOF'

cmake_minimum_required(VERSION 3.13.4)

project(llvm_devel_components_test

 VERSION "0.1"

 LANGUAGES C CXX)



find_package(LLVM REQUIRED CONFIG

 COMPONENTS

 core

 support

 bitwriter

 irreader

)



message(STATUS "LLVM package with COMPONENTS found successfully")

message(STATUS "LLVM version: ${LLVM_VERSION}")

CMAKEEOF



 rlRun "cmake -S $TmpDir -B $TmpDir/build_components" 0 \

 "cmake configuration (find_package LLVM with COMPONENTS)"

 fi

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd
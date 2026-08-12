#!/bin/bash
# Functional test: llvm22-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
# Issue: https://github.com/openRuyi-Project/openRuyi/issues/760
# Problem: LLVMExports.cmake references non-existent .a files (e.g. libLLVMTestingAnnotations.a)
#          causing find_package(LLVM) to fail during configuration
#
# Verification principle:
#   find_package(LLVM) -> LLVMConfig.cmake -> LLVMExports.cmake
#   LLVMExports.cmake is the only file listing all target->file mappings,
#   and validates each referenced .a/.so during loading.
#   Other .cmake files (AddLLVM, CheckAtomic, etc.) are internal build helpers,
#   not loaded during find_package, and do not contain file path references,
#   so they do not trigger issue#760-style problems.

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="llvm22-devel"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter temporary test directory"

        # Auto-detect LLVM cmake directory
        LLVM_CMAKE_DIR=$(rpm -ql "$PKG" | grep 'LLVMConfig\.cmake$' | head -1 | xargs dirname)
        rlLogInfo "LLVM cmake directory: $LLVM_CMAKE_DIR"

        # Count .cmake files
        CMAKE_COUNT=$(rpm -ql "$PKG" | grep -c '\.cmake$')
        rlLogInfo "$PKG provides $CMAKE_COUNT .cmake file(s)"
    rlPhaseEnd

    rlPhaseStartTest "find_package(LLVM) COMPONENTS - Verify LLVMExports.cmake export integrity"
        if [ "$CMAKE_COUNT" -eq 0 ]; then
            rlLogWarning "$PKG provides no .cmake files, skipping cmake verification"
        else
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
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
EOF

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
#!/bin/bash
# Functional test: python-torch - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="python-torch"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter temporary test directory"

        CMAKE_COUNT=$(rpm -ql "$PKG" 2>/dev/null | grep -c '\.cmake$' || echo 0)
        rlLogInfo "$PKG provides $CMAKE_COUNT .cmake file(s)"
    rlPhaseEnd

    rlPhaseStartTest "find_package(CONFIG) - Verify cmake export integrity"
        if [ "$CMAKE_COUNT" -eq 0 ]; then
            rlLogWarning "$PKG provides no .cmake files, skipping cmake verification"
        else
            # --- find_package(ATen) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(ATen REQUIRED CONFIG
  PATHS /usr/lib64/python3.13/site-packages/torch/share/cmake/ATen
  NO_DEFAULT_PATH)

message(STATUS "find_package(ATen) succeeded")
EOF

            rlLogInfo "Verifying find_package(ATen CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package ATen CONFIG)"; then
                rlPass "find_package(ATen CONFIG) verification passed"
            else
                rlFail "find_package(ATen CONFIG) verification failed"
            fi

            # --- find_package(Caffe2) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Caffe2 REQUIRED CONFIG
  PATHS /usr/lib64/python3.13/site-packages/torch/share/cmake/Caffe2
  NO_DEFAULT_PATH)

message(STATUS "find_package(Caffe2) succeeded")
EOF

            rlLogInfo "Verifying find_package(Caffe2 CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Caffe2 CONFIG)"; then
                rlPass "find_package(Caffe2 CONFIG) verification passed"
            else
                rlFail "find_package(Caffe2 CONFIG) verification failed"
            fi

            # --- find_package(Torch) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Torch REQUIRED CONFIG
  PATHS /usr/lib64/python3.13/site-packages/torch/share/cmake/Torch
  NO_DEFAULT_PATH)

message(STATUS "find_package(Torch) succeeded")
EOF

            rlLogInfo "Verifying find_package(Torch CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Torch CONFIG)"; then
                rlPass "find_package(Torch CONFIG) verification passed"
            else
                rlFail "find_package(Torch CONFIG) verification failed"
            fi

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

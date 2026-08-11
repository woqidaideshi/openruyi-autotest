#!/bin/bash
# Functional test: arrow-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="arrow-devel"

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
            # --- find_package(Arrow) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Arrow REQUIRED CONFIG)

message(STATUS "find_package(Arrow) succeeded")
EOF

            rlLogInfo "Verifying find_package(Arrow CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Arrow CONFIG)"; then
                rlPass "find_package(Arrow CONFIG) verification passed"
            else
                rlFail "find_package(Arrow CONFIG) verification failed"
            fi

            # --- find_package(ArrowAcero) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(ArrowAcero REQUIRED CONFIG)

message(STATUS "find_package(ArrowAcero) succeeded")
EOF

            rlLogInfo "Verifying find_package(ArrowAcero CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package ArrowAcero CONFIG)"; then
                rlPass "find_package(ArrowAcero CONFIG) verification passed"
            else
                rlFail "find_package(ArrowAcero CONFIG) verification failed"
            fi

            # --- find_package(ArrowCompute) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(ArrowCompute REQUIRED CONFIG)

message(STATUS "find_package(ArrowCompute) succeeded")
EOF

            rlLogInfo "Verifying find_package(ArrowCompute CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package ArrowCompute CONFIG)"; then
                rlPass "find_package(ArrowCompute CONFIG) verification passed"
            else
                rlFail "find_package(ArrowCompute CONFIG) verification failed"
            fi

            # --- find_package(ArrowDataset) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(ArrowDataset REQUIRED CONFIG)

message(STATUS "find_package(ArrowDataset) succeeded")
EOF

            rlLogInfo "Verifying find_package(ArrowDataset CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package ArrowDataset CONFIG)"; then
                rlPass "find_package(ArrowDataset CONFIG) verification passed"
            else
                rlFail "find_package(ArrowDataset CONFIG) verification failed"
            fi

            # --- find_package(Parquet) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Parquet REQUIRED CONFIG)

message(STATUS "find_package(Parquet) succeeded")
EOF

            rlLogInfo "Verifying find_package(Parquet CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Parquet CONFIG)"; then
                rlPass "find_package(Parquet CONFIG) verification passed"
            else
                rlFail "find_package(Parquet CONFIG) verification failed"
            fi

            # --- find_package(arrow) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(arrow REQUIRED CONFIG)

message(STATUS "find_package(arrow) succeeded")
EOF

            rlLogInfo "Verifying find_package(arrow CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package arrow CONFIG)"; then
                rlPass "find_package(arrow CONFIG) verification passed"
            else
                rlFail "find_package(arrow CONFIG) verification failed"
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

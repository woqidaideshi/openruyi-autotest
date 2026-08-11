#!/bin/bash
# Functional test: fftw-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="fftw-devel"

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
            # --- find_package(FFTW3) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FFTW3 REQUIRED CONFIG)

message(STATUS "find_package(FFTW3) succeeded")
EOF

            rlLogInfo "Verifying find_package(FFTW3 CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package FFTW3 CONFIG)"; then
                rlPass "find_package(FFTW3 CONFIG) verification passed"
            else
                rlFail "find_package(FFTW3 CONFIG) verification failed"
            fi

            # --- find_package(FFTW3f) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FFTW3f REQUIRED CONFIG
  PATHS /usr/lib64/cmake/fftw3
  NO_DEFAULT_PATH)

message(STATUS "find_package(FFTW3f) succeeded")
EOF

            rlLogInfo "Verifying find_package(FFTW3f CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package FFTW3f CONFIG)"; then
                rlPass "find_package(FFTW3f CONFIG) verification passed"
            else
                rlFail "find_package(FFTW3f CONFIG) verification failed"
            fi

            # --- find_package(FFTW3l) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FFTW3l REQUIRED CONFIG
  PATHS /usr/lib64/cmake/fftw3
  NO_DEFAULT_PATH)

message(STATUS "find_package(FFTW3l) succeeded")
EOF

            rlLogInfo "Verifying find_package(FFTW3l CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package FFTW3l CONFIG)"; then
                rlPass "find_package(FFTW3l CONFIG) verification passed"
            else
                rlFail "find_package(FFTW3l CONFIG) verification failed"
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

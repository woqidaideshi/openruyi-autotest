#!/bin/bash
# Functional test: spirv-tools-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="spirv-tools-devel"

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
            # --- find_package(SPIRV-Tools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package SPIRV-Tools CONFIG)"; then
                rlPass "find_package(SPIRV-Tools CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools CONFIG) verification failed"
            fi

            # --- find_package(SPIRV-Tools-diff) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools-opt CONFIG QUIET)
find_package(SPIRV-Tools-diff REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools-diff) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools-diff CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package SPIRV-Tools-diff CONFIG)"; then
                rlPass "find_package(SPIRV-Tools-diff CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools-diff CONFIG) verification failed"
            fi

            # --- find_package(SPIRV-Tools-link) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools-opt CONFIG QUIET)
find_package(SPIRV-Tools-link REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools-link) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools-link CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package SPIRV-Tools-link CONFIG)"; then
                rlPass "find_package(SPIRV-Tools-link CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools-link CONFIG) verification failed"
            fi

            # --- find_package(SPIRV-Tools-lint) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools-opt CONFIG QUIET)
find_package(SPIRV-Tools-lint REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools-lint) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools-lint CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package SPIRV-Tools-lint CONFIG)"; then
                rlPass "find_package(SPIRV-Tools-lint CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools-lint CONFIG) verification failed"
            fi

            # --- find_package(SPIRV-Tools-opt) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools-opt REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools-opt) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools-opt CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package SPIRV-Tools-opt CONFIG)"; then
                rlPass "find_package(SPIRV-Tools-opt CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools-opt CONFIG) verification failed"
            fi

            # --- find_package(SPIRV-Tools-reduce) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools-opt CONFIG QUIET)
find_package(SPIRV-Tools-reduce REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools-reduce) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools-reduce CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package SPIRV-Tools-reduce CONFIG)"; then
                rlPass "find_package(SPIRV-Tools-reduce CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools-reduce CONFIG) verification failed"
            fi

            # --- find_package(SPIRV-Tools-tools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(SPIRV-Tools-tools REQUIRED CONFIG)

message(STATUS "find_package(SPIRV-Tools-tools) succeeded")
EOF

            rlLogInfo "Verifying find_package(SPIRV-Tools-tools CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package SPIRV-Tools-tools CONFIG)"; then
                rlPass "find_package(SPIRV-Tools-tools CONFIG) verification passed"
            else
                rlFail "find_package(SPIRV-Tools-tools CONFIG) verification failed"
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

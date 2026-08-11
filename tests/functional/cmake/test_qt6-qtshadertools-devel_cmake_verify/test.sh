#!/bin/bash
# Functional test: qt6-qtshadertools-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtshadertools-devel"

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
            # --- find_package(Qt6ShaderTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6ShaderTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6ShaderTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ShaderTools CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Qt6ShaderTools CONFIG)"; then
                rlPass "find_package(Qt6ShaderTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ShaderTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6ShaderToolsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ShaderToolsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ShaderToolsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ShaderToolsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6ShaderToolsPrivate CONFIG)"; then
                rlPass "find_package(Qt6ShaderToolsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ShaderToolsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ShaderToolsTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ShaderToolsTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6ShaderToolsTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ShaderToolsTools CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6ShaderToolsTools CONFIG)"; then
                rlPass "find_package(Qt6ShaderToolsTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ShaderToolsTools CONFIG) verification failed"
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

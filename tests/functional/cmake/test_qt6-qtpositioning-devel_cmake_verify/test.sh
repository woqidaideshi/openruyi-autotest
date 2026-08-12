#!/bin/bash
# Functional test: qt6-qtpositioning-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtpositioning-devel"

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

            # --- find_package(Qt6Positioning) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Positioning REQUIRED CONFIG)

message(STATUS "find_package(Qt6Positioning) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Positioning CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6Positioning CONFIG)"; then
                rlPass "find_package(Qt6Positioning CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Positioning CONFIG) verification failed"
            fi

            # --- find_package(Qt6PositioningPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PositioningPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PositioningPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PositioningPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6PositioningPrivate CONFIG)"; then
                rlPass "find_package(Qt6PositioningPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PositioningPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6PositioningQuick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6PositioningQuick REQUIRED CONFIG)

message(STATUS "find_package(Qt6PositioningQuick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PositioningQuick CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6PositioningQuick CONFIG)"; then
                rlPass "find_package(Qt6PositioningQuick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PositioningQuick CONFIG) verification failed"
            fi

            # --- find_package(Qt6PositioningQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PositioningQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PositioningQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PositioningQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6PositioningQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6PositioningQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PositioningQuickPrivate CONFIG) verification failed"
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

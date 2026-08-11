#!/bin/bash
# Functional test: plasma-workspace-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="plasma-workspace-devel"

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
            # --- find_package(KRunnerAppDBusInterface) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(KRunnerAppDBusInterface REQUIRED CONFIG)

message(STATUS "find_package(KRunnerAppDBusInterface) succeeded")
EOF

            rlLogInfo "Verifying find_package(KRunnerAppDBusInterface CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package KRunnerAppDBusInterface CONFIG)"; then
                rlPass "find_package(KRunnerAppDBusInterface CONFIG) verification passed"
            else
                rlFail "find_package(KRunnerAppDBusInterface CONFIG) verification failed"
            fi

            # --- find_package(KSMServerDBusInterface) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(KSMServerDBusInterface REQUIRED CONFIG)

message(STATUS "find_package(KSMServerDBusInterface) succeeded")
EOF

            rlLogInfo "Verifying find_package(KSMServerDBusInterface CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package KSMServerDBusInterface CONFIG)"; then
                rlPass "find_package(KSMServerDBusInterface CONFIG) verification passed"
            else
                rlFail "find_package(KSMServerDBusInterface CONFIG) verification failed"
            fi

            # --- find_package(Krdb) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Krdb REQUIRED CONFIG)

message(STATUS "find_package(Krdb) succeeded")
EOF

            rlLogInfo "Verifying find_package(Krdb CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Krdb CONFIG)"; then
                rlPass "find_package(Krdb CONFIG) verification passed"
            else
                rlFail "find_package(Krdb CONFIG) verification failed"
            fi

            # --- find_package(LibKLookAndFeel) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(LibKLookAndFeel REQUIRED CONFIG)

message(STATUS "find_package(LibKLookAndFeel) succeeded")
EOF

            rlLogInfo "Verifying find_package(LibKLookAndFeel CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package LibKLookAndFeel CONFIG)"; then
                rlPass "find_package(LibKLookAndFeel CONFIG) verification passed"
            else
                rlFail "find_package(LibKLookAndFeel CONFIG) verification failed"
            fi

            # --- find_package(LibKWorkspace) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(LibKWorkspace REQUIRED CONFIG)

message(STATUS "find_package(LibKWorkspace) succeeded")
EOF

            rlLogInfo "Verifying find_package(LibKWorkspace CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package LibKWorkspace CONFIG)"; then
                rlPass "find_package(LibKWorkspace CONFIG) verification passed"
            else
                rlFail "find_package(LibKWorkspace CONFIG) verification failed"
            fi

            # --- find_package(LibNotificationManager) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(LibNotificationManager REQUIRED CONFIG)

message(STATUS "find_package(LibNotificationManager) succeeded")
EOF

            rlLogInfo "Verifying find_package(LibNotificationManager CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package LibNotificationManager CONFIG)"; then
                rlPass "find_package(LibNotificationManager CONFIG) verification passed"
            else
                rlFail "find_package(LibNotificationManager CONFIG) verification failed"
            fi

            # --- find_package(LibTaskManager) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(LibTaskManager REQUIRED CONFIG)

message(STATUS "find_package(LibTaskManager) succeeded")
EOF

            rlLogInfo "Verifying find_package(LibTaskManager CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package LibTaskManager CONFIG)"; then
                rlPass "find_package(LibTaskManager CONFIG) verification passed"
            else
                rlFail "find_package(LibTaskManager CONFIG) verification failed"
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

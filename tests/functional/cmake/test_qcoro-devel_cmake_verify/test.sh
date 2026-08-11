#!/bin/bash
# Functional test: qcoro-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qcoro-devel"

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
            # --- find_package(QCoro6) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6 REQUIRED CONFIG
  COMPONENTS
    Core
)

message(STATUS "find_package(QCoro6) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6 CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package QCoro6 CONFIG)"; then
                rlPass "find_package(QCoro6 CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6 CONFIG) verification failed"
            fi

            # --- find_package(QCoro6Core) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6Core REQUIRED CONFIG)

message(STATUS "find_package(QCoro6Core) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6Core CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package QCoro6Core CONFIG)"; then
                rlPass "find_package(QCoro6Core CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6Core CONFIG) verification failed"
            fi

            # --- find_package(QCoro6Coro) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6Coro REQUIRED CONFIG)

message(STATUS "find_package(QCoro6Coro) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6Coro CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package QCoro6Coro CONFIG)"; then
                rlPass "find_package(QCoro6Coro CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6Coro CONFIG) verification failed"
            fi

            # --- find_package(QCoro6DBus) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6DBus REQUIRED CONFIG)

message(STATUS "find_package(QCoro6DBus) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6DBus CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package QCoro6DBus CONFIG)"; then
                rlPass "find_package(QCoro6DBus CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6DBus CONFIG) verification failed"
            fi

            # --- find_package(QCoro6Network) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6Network REQUIRED CONFIG)

message(STATUS "find_package(QCoro6Network) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6Network CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package QCoro6Network CONFIG)"; then
                rlPass "find_package(QCoro6Network CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6Network CONFIG) verification failed"
            fi

            # --- find_package(QCoro6Qml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6Qml REQUIRED CONFIG)

message(STATUS "find_package(QCoro6Qml) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6Qml CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package QCoro6Qml CONFIG)"; then
                rlPass "find_package(QCoro6Qml CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6Qml CONFIG) verification failed"
            fi

            # --- find_package(QCoro6Quick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6Quick REQUIRED CONFIG)

message(STATUS "find_package(QCoro6Quick) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6Quick CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package QCoro6Quick CONFIG)"; then
                rlPass "find_package(QCoro6Quick CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6Quick CONFIG) verification failed"
            fi

            # --- find_package(QCoro6Test) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6Test REQUIRED CONFIG)

message(STATUS "find_package(QCoro6Test) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6Test CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package QCoro6Test CONFIG)"; then
                rlPass "find_package(QCoro6Test CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6Test CONFIG) verification failed"
            fi

            # --- find_package(QCoro6WebSockets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(QCoro6WebSockets REQUIRED CONFIG)

message(STATUS "find_package(QCoro6WebSockets) succeeded")
EOF

            rlLogInfo "Verifying find_package(QCoro6WebSockets CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package QCoro6WebSockets CONFIG)"; then
                rlPass "find_package(QCoro6WebSockets CONFIG) verification passed"
            else
                rlFail "find_package(QCoro6WebSockets CONFIG) verification failed"
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

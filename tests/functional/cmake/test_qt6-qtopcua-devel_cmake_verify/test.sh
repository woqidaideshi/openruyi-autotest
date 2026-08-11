#!/bin/bash
# Functional test: qt6-qtopcua-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtopcua-devel"

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

            # --- find_package(Qt6DeclarativeOpcua) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6DeclarativeOpcua REQUIRED CONFIG)

message(STATUS "find_package(Qt6DeclarativeOpcua) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DeclarativeOpcua CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6DeclarativeOpcua CONFIG)"; then
                rlPass "find_package(Qt6DeclarativeOpcua CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DeclarativeOpcua CONFIG) verification failed"
            fi

            # --- find_package(Qt6DeclarativeOpcuaPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6DeclarativeOpcuaPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6DeclarativeOpcuaPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DeclarativeOpcuaPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6DeclarativeOpcuaPrivate CONFIG)"; then
                rlPass "find_package(Qt6DeclarativeOpcuaPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DeclarativeOpcuaPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6OpcUa) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6OpcUa REQUIRED CONFIG)

message(STATUS "find_package(Qt6OpcUa) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6OpcUa CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6OpcUa CONFIG)"; then
                rlPass "find_package(Qt6OpcUa CONFIG) verification passed"
            else
                rlFail "find_package(Qt6OpcUa CONFIG) verification failed"
            fi

            # --- find_package(Qt6OpcUaPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6OpcUaPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6OpcUaPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6OpcUaPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6OpcUaPrivate CONFIG)"; then
                rlPass "find_package(Qt6OpcUaPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6OpcUaPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6OpcUaTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6OpcUaTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6OpcUaTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6OpcUaTools CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6OpcUaTools CONFIG)"; then
                rlPass "find_package(Qt6OpcUaTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6OpcUaTools CONFIG) verification failed"
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

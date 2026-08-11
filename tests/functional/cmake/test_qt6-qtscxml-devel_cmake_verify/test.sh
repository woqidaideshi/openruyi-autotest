#!/bin/bash
# Functional test: qt6-qtscxml-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtscxml-devel"

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

            # --- find_package(Qt6Scxml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Scxml REQUIRED CONFIG)

message(STATUS "find_package(Qt6Scxml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Scxml CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6Scxml CONFIG)"; then
                rlPass "find_package(Qt6Scxml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Scxml CONFIG) verification failed"
            fi

            # --- find_package(Qt6ScxmlGlobalPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ScxmlGlobalPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ScxmlGlobalPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ScxmlGlobalPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6ScxmlGlobalPrivate CONFIG)"; then
                rlPass "find_package(Qt6ScxmlGlobalPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ScxmlGlobalPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ScxmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ScxmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ScxmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ScxmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6ScxmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6ScxmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ScxmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ScxmlQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6ScxmlQml REQUIRED CONFIG)

message(STATUS "find_package(Qt6ScxmlQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ScxmlQml CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6ScxmlQml CONFIG)"; then
                rlPass "find_package(Qt6ScxmlQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ScxmlQml CONFIG) verification failed"
            fi

            # --- find_package(Qt6ScxmlQmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ScxmlQmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ScxmlQmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ScxmlQmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6ScxmlQmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6ScxmlQmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ScxmlQmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ScxmlTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ScxmlTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6ScxmlTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ScxmlTools CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6ScxmlTools CONFIG)"; then
                rlPass "find_package(Qt6ScxmlTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ScxmlTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6StateMachine) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6StateMachine REQUIRED CONFIG)

message(STATUS "find_package(Qt6StateMachine) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6StateMachine CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6StateMachine CONFIG)"; then
                rlPass "find_package(Qt6StateMachine CONFIG) verification passed"
            else
                rlFail "find_package(Qt6StateMachine CONFIG) verification failed"
            fi

            # --- find_package(Qt6StateMachinePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6StateMachinePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6StateMachinePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6StateMachinePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6StateMachinePrivate CONFIG)"; then
                rlPass "find_package(Qt6StateMachinePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6StateMachinePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6StateMachineQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6StateMachineQml REQUIRED CONFIG)

message(STATUS "find_package(Qt6StateMachineQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6StateMachineQml CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6StateMachineQml CONFIG)"; then
                rlPass "find_package(Qt6StateMachineQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6StateMachineQml CONFIG) verification failed"
            fi

            # --- find_package(Qt6StateMachineQmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6StateMachineQmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6StateMachineQmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6StateMachineQmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6StateMachineQmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6StateMachineQmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6StateMachineQmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6declarative_scxml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6declarative_scxml CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH)

message(STATUS "find_package(Qt6declarative_scxml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6declarative_scxml CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6declarative_scxml CONFIG)"; then
                rlPass "find_package(Qt6declarative_scxml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6declarative_scxml CONFIG) verification failed"
            fi

            # --- find_package(Qt6qtqmlstatemachine) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6qtqmlstatemachine CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH)

message(STATUS "find_package(Qt6qtqmlstatemachine) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6qtqmlstatemachine CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6qtqmlstatemachine CONFIG)"; then
                rlPass "find_package(Qt6qtqmlstatemachine CONFIG) verification passed"
            else
                rlFail "find_package(Qt6qtqmlstatemachine CONFIG) verification failed"
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

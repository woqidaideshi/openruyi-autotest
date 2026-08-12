#!/bin/bash
# Functional test: qt6-qtremoteobjects-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtremoteobjects-devel"

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

            # --- find_package(Qt6RemoteObjects) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6RemoteObjects REQUIRED CONFIG)

message(STATUS "find_package(Qt6RemoteObjects) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6RemoteObjects CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6RemoteObjects CONFIG)"; then
                rlPass "find_package(Qt6RemoteObjects CONFIG) verification passed"
            else
                rlFail "find_package(Qt6RemoteObjects CONFIG) verification failed"
            fi

            # --- find_package(Qt6RemoteObjectsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6RemoteObjectsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6RemoteObjectsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6RemoteObjectsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6RemoteObjectsPrivate CONFIG)"; then
                rlPass "find_package(Qt6RemoteObjectsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6RemoteObjectsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6RemoteObjectsQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6RemoteObjectsQml REQUIRED CONFIG)

message(STATUS "find_package(Qt6RemoteObjectsQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6RemoteObjectsQml CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6RemoteObjectsQml CONFIG)"; then
                rlPass "find_package(Qt6RemoteObjectsQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6RemoteObjectsQml CONFIG) verification failed"
            fi

            # --- find_package(Qt6RemoteObjectsQmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6RemoteObjectsQmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6RemoteObjectsQmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6RemoteObjectsQmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6RemoteObjectsQmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6RemoteObjectsQmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6RemoteObjectsQmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6RemoteObjectsTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6RemoteObjectsTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6RemoteObjectsTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6RemoteObjectsTools CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6RemoteObjectsTools CONFIG)"; then
                rlPass "find_package(Qt6RemoteObjectsTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6RemoteObjectsTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6RepParser) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6RepParser REQUIRED CONFIG)

message(STATUS "find_package(Qt6RepParser) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6RepParser CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6RepParser CONFIG)"; then
                rlPass "find_package(Qt6RepParser CONFIG) verification passed"
            else
                rlFail "find_package(Qt6RepParser CONFIG) verification failed"
            fi

            # --- find_package(Qt6declarative_remoteobjects) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6declarative_remoteobjects CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH
)

message(STATUS "find_package(Qt6declarative_remoteobjects) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6declarative_remoteobjects CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6declarative_remoteobjects CONFIG)"; then
                rlPass "find_package(Qt6declarative_remoteobjects CONFIG) verification passed"
            else
                rlFail "find_package(Qt6declarative_remoteobjects CONFIG) verification failed"
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

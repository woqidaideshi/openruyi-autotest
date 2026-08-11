#!/bin/bash
# Functional test: qt6-qtcharts-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtcharts-devel"

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

            # --- find_package(Qt6Charts) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Charts REQUIRED CONFIG)

message(STATUS "find_package(Qt6Charts) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Charts CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6Charts CONFIG)"; then
                rlPass "find_package(Qt6Charts CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Charts CONFIG) verification failed"
            fi

            # --- find_package(Qt6ChartsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ChartsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ChartsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ChartsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6ChartsPrivate CONFIG)"; then
                rlPass "find_package(Qt6ChartsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ChartsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ChartsQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6ChartsQml REQUIRED CONFIG)

message(STATUS "find_package(Qt6ChartsQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ChartsQml CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6ChartsQml CONFIG)"; then
                rlPass "find_package(Qt6ChartsQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ChartsQml CONFIG) verification failed"
            fi

            # --- find_package(Qt6ChartsQmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ChartsQmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ChartsQmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ChartsQmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6ChartsQmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6ChartsQmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ChartsQmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6qtchartsqml2) ---
            # QML plugin config is under QmlPlugins/, not in default cmake search path
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6qtchartsqml2 CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH
)

message(STATUS "find_package(Qt6qtchartsqml2) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6qtchartsqml2 CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6qtchartsqml2 CONFIG)"; then
                rlPass "find_package(Qt6qtchartsqml2 CONFIG) verification passed"
            else
                rlFail "find_package(Qt6qtchartsqml2 CONFIG) verification failed"
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

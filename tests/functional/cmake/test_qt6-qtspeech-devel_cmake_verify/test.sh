#!/bin/bash
# Functional test: qt6-qtspeech-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtspeech-devel"

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

            # --- find_package(Qt6TextToSpeech) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6TextToSpeech REQUIRED CONFIG)

message(STATUS "find_package(Qt6TextToSpeech) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6TextToSpeech CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6TextToSpeech CONFIG)"; then
                rlPass "find_package(Qt6TextToSpeech CONFIG) verification passed"
            else
                rlFail "find_package(Qt6TextToSpeech CONFIG) verification failed"
            fi

            # --- find_package(Qt6TextToSpeechPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6TextToSpeechPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6TextToSpeechPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6TextToSpeechPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6TextToSpeechPrivate CONFIG)"; then
                rlPass "find_package(Qt6TextToSpeechPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6TextToSpeechPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6TextToSpeechQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6TextToSpeechQml CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH)

message(STATUS "find_package(Qt6TextToSpeechQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6TextToSpeechQml CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6TextToSpeechQml CONFIG)"; then
                rlPass "find_package(Qt6TextToSpeechQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6TextToSpeechQml CONFIG) verification failed"
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

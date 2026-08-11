#!/bin/bash
# Functional test: qt6-qtmultimedia-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtmultimedia-devel"

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

            # --- find_package(Qt6BundledResonanceAudio) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6BundledResonanceAudio REQUIRED CONFIG)

message(STATUS "find_package(Qt6BundledResonanceAudio) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6BundledResonanceAudio CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6BundledResonanceAudio CONFIG)"; then
                rlPass "find_package(Qt6BundledResonanceAudio CONFIG) verification passed"
            else
                rlFail "find_package(Qt6BundledResonanceAudio CONFIG) verification failed"
            fi

            # --- find_package(Qt6Multimedia) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Multimedia REQUIRED CONFIG)

message(STATUS "find_package(Qt6Multimedia) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Multimedia CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6Multimedia CONFIG)"; then
                rlPass "find_package(Qt6Multimedia CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Multimedia CONFIG) verification failed"
            fi

            # --- find_package(Qt6MultimediaPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6MultimediaPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6MultimediaPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6MultimediaPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6MultimediaPrivate CONFIG)"; then
                rlPass "find_package(Qt6MultimediaPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6MultimediaPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6MultimediaQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6MultimediaQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6MultimediaQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6MultimediaQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6MultimediaQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6MultimediaQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6MultimediaQuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6MultimediaTestLibPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6MultimediaTestLibPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6MultimediaTestLibPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6MultimediaTestLibPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6MultimediaTestLibPrivate CONFIG)"; then
                rlPass "find_package(Qt6MultimediaTestLibPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6MultimediaTestLibPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6MultimediaWidgets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6MultimediaWidgets REQUIRED CONFIG)

message(STATUS "find_package(Qt6MultimediaWidgets) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6MultimediaWidgets CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6MultimediaWidgets CONFIG)"; then
                rlPass "find_package(Qt6MultimediaWidgets CONFIG) verification passed"
            else
                rlFail "find_package(Qt6MultimediaWidgets CONFIG) verification failed"
            fi

            # --- find_package(Qt6MultimediaWidgetsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6MultimediaWidgetsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6MultimediaWidgetsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6MultimediaWidgetsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6MultimediaWidgetsPrivate CONFIG)"; then
                rlPass "find_package(Qt6MultimediaWidgetsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6MultimediaWidgetsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DSpatialAudioPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DSpatialAudioPrivate CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH
)

message(STATUS "find_package(Qt6Quick3DSpatialAudioPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DSpatialAudioPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6Quick3DSpatialAudioPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DSpatialAudioPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DSpatialAudioPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6SpatialAudio) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6SpatialAudio REQUIRED CONFIG)

message(STATUS "find_package(Qt6SpatialAudio) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6SpatialAudio CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6SpatialAudio CONFIG)"; then
                rlPass "find_package(Qt6SpatialAudio CONFIG) verification passed"
            else
                rlFail "find_package(Qt6SpatialAudio CONFIG) verification failed"
            fi

            # --- find_package(Qt6SpatialAudioPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6SpatialAudioPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6SpatialAudioPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6SpatialAudioPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6SpatialAudioPrivate CONFIG)"; then
                rlPass "find_package(Qt6SpatialAudioPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6SpatialAudioPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6quick3dspatialaudio) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6quick3dspatialaudio CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH
)

message(STATUS "find_package(Qt6quick3dspatialaudio) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6quick3dspatialaudio CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6quick3dspatialaudio CONFIG)"; then
                rlPass "find_package(Qt6quick3dspatialaudio CONFIG) verification passed"
            else
                rlFail "find_package(Qt6quick3dspatialaudio CONFIG) verification failed"
            fi

            # --- find_package(Qt6quickmultimedia) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6quickmultimedia CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH
)

message(STATUS "find_package(Qt6quickmultimedia) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6quickmultimedia CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6quickmultimedia CONFIG)"; then
                rlPass "find_package(Qt6quickmultimedia CONFIG) verification passed"
            else
                rlFail "find_package(Qt6quickmultimedia CONFIG) verification failed"
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

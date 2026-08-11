#!/bin/bash
# Functional test: qt6-qtvirtualkeyboard-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtvirtualkeyboard-devel"

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

            # --- find_package(Qt6Gui) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Gui REQUIRED CONFIG)

message(STATUS "find_package(Qt6Gui) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Gui CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6Gui CONFIG)"; then
                rlPass "find_package(Qt6Gui CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Gui CONFIG) verification failed"
            fi

            # --- find_package(Qt6HunspellInputMethod) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6HunspellInputMethod REQUIRED CONFIG)

message(STATUS "find_package(Qt6HunspellInputMethod) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6HunspellInputMethod CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6HunspellInputMethod CONFIG)"; then
                rlPass "find_package(Qt6HunspellInputMethod CONFIG) verification passed"
            else
                rlFail "find_package(Qt6HunspellInputMethod CONFIG) verification failed"
            fi

            # --- find_package(Qt6HunspellInputMethodPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6HunspellInputMethodPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6HunspellInputMethodPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6HunspellInputMethodPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6HunspellInputMethodPrivate CONFIG)"; then
                rlPass "find_package(Qt6HunspellInputMethodPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6HunspellInputMethodPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6VirtualKeyboard) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6VirtualKeyboard REQUIRED CONFIG)

message(STATUS "find_package(Qt6VirtualKeyboard) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6VirtualKeyboard CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6VirtualKeyboard CONFIG)"; then
                rlPass "find_package(Qt6VirtualKeyboard CONFIG) verification passed"
            else
                rlFail "find_package(Qt6VirtualKeyboard CONFIG) verification failed"
            fi

            # --- find_package(Qt6VirtualKeyboardPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6VirtualKeyboardPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6VirtualKeyboardPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6VirtualKeyboardPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6VirtualKeyboardPrivate CONFIG)"; then
                rlPass "find_package(Qt6VirtualKeyboardPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6VirtualKeyboardPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6VirtualKeyboardQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6VirtualKeyboardQml REQUIRED CONFIG)

message(STATUS "find_package(Qt6VirtualKeyboardQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6VirtualKeyboardQml CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6VirtualKeyboardQml CONFIG)"; then
                rlPass "find_package(Qt6VirtualKeyboardQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6VirtualKeyboardQml CONFIG) verification failed"
            fi

            # --- find_package(Qt6VirtualKeyboardQmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6VirtualKeyboardQmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6VirtualKeyboardQmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6VirtualKeyboardQmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6VirtualKeyboardQmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6VirtualKeyboardQmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6VirtualKeyboardQmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6VirtualKeyboardSettings) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6VirtualKeyboardSettings REQUIRED CONFIG)

message(STATUS "find_package(Qt6VirtualKeyboardSettings) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6VirtualKeyboardSettings CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6VirtualKeyboardSettings CONFIG)"; then
                rlPass "find_package(Qt6VirtualKeyboardSettings CONFIG) verification passed"
            else
                rlFail "find_package(Qt6VirtualKeyboardSettings CONFIG) verification failed"
            fi

            # --- find_package(Qt6VirtualKeyboardSettingsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6VirtualKeyboardSettingsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6VirtualKeyboardSettingsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6VirtualKeyboardSettingsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6VirtualKeyboardSettingsPrivate CONFIG)"; then
                rlPass "find_package(Qt6VirtualKeyboardSettingsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6VirtualKeyboardSettingsPrivate CONFIG) verification failed"
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

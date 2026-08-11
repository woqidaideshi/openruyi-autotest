#!/bin/bash
# Functional test: fcitx5-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="fcitx5-devel"

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
            # --- find_package(Fcitx5Config) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5Config REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5Config) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5Config CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Fcitx5Config CONFIG)"; then
                rlPass "find_package(Fcitx5Config CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5Config CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5Core) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5Core REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5Core) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5Core CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Fcitx5Core CONFIG)"; then
                rlPass "find_package(Fcitx5Core CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5Core CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5Module) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5Module REQUIRED CONFIG
  COMPONENTS
    Clipboard
)

message(STATUS "find_package(Fcitx5Module) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5Module CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Fcitx5Module CONFIG)"; then
                rlPass "find_package(Fcitx5Module CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5Module CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleClipboard) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleClipboard REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleClipboard) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleClipboard CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Fcitx5ModuleClipboard CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleClipboard CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleClipboard CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleDBus) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleDBus REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleDBus) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleDBus CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Fcitx5ModuleDBus CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleDBus CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleDBus CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleEmoji) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleEmoji REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleEmoji) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleEmoji CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Fcitx5ModuleEmoji CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleEmoji CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleEmoji CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleNotificationItem) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleNotificationItem REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleNotificationItem) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleNotificationItem CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Fcitx5ModuleNotificationItem CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleNotificationItem CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleNotificationItem CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleNotifications) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleNotifications REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleNotifications) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleNotifications CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Fcitx5ModuleNotifications CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleNotifications CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleNotifications CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleQuickPhrase) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleQuickPhrase REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleQuickPhrase) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleQuickPhrase CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Fcitx5ModuleQuickPhrase CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleQuickPhrase CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleQuickPhrase CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleSpell) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleSpell REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleSpell) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleSpell CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Fcitx5ModuleSpell CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleSpell CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleSpell CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleTestFrontend) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleTestFrontend REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleTestFrontend) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleTestFrontend CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Fcitx5ModuleTestFrontend CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleTestFrontend CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleTestFrontend CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleTestIM) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleTestIM REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleTestIM) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleTestIM CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Fcitx5ModuleTestIM CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleTestIM CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleTestIM CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleUnicode) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleUnicode REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleUnicode) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleUnicode CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Fcitx5ModuleUnicode CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleUnicode CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleUnicode CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleWayland) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleWayland REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleWayland) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleWayland CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Fcitx5ModuleWayland CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleWayland CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleWayland CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5ModuleXCB) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5ModuleXCB REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5ModuleXCB) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5ModuleXCB CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Fcitx5ModuleXCB CONFIG)"; then
                rlPass "find_package(Fcitx5ModuleXCB CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5ModuleXCB CONFIG) verification failed"
            fi

            # --- find_package(Fcitx5Utils) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Fcitx5Utils REQUIRED CONFIG)

message(STATUS "find_package(Fcitx5Utils) succeeded")
EOF

            rlLogInfo "Verifying find_package(Fcitx5Utils CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Fcitx5Utils CONFIG)"; then
                rlPass "find_package(Fcitx5Utils CONFIG) verification passed"
            else
                rlFail "find_package(Fcitx5Utils CONFIG) verification failed"
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

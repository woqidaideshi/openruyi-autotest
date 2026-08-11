#!/bin/bash
# Functional test: qt6-qtbase-private-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtbase-private-devel"

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
            # --- find_package(Qt6CorePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6CorePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6CorePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6CorePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Qt6CorePrivate CONFIG)"; then
                rlPass "find_package(Qt6CorePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6CorePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6DBusPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6DBusPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6DBusPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DBusPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6DBusPrivate CONFIG)"; then
                rlPass "find_package(Qt6DBusPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DBusPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6DeviceDiscoverySupportPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6DeviceDiscoverySupportPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6DeviceDiscoverySupportPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DeviceDiscoverySupportPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6DeviceDiscoverySupportPrivate CONFIG)"; then
                rlPass "find_package(Qt6DeviceDiscoverySupportPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DeviceDiscoverySupportPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6EglFSDeviceIntegrationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6EglFSDeviceIntegrationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6EglFSDeviceIntegrationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6EglFSDeviceIntegrationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6EglFSDeviceIntegrationPrivate CONFIG)"; then
                rlPass "find_package(Qt6EglFSDeviceIntegrationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6EglFSDeviceIntegrationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6FbSupportPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6FbSupportPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6FbSupportPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6FbSupportPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6FbSupportPrivate CONFIG)"; then
                rlPass "find_package(Qt6FbSupportPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6FbSupportPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6GuiPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6GuiPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6GuiPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6GuiPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6GuiPrivate CONFIG)"; then
                rlPass "find_package(Qt6GuiPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6GuiPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6InputSupportPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6InputSupportPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6InputSupportPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6InputSupportPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6InputSupportPrivate CONFIG)"; then
                rlPass "find_package(Qt6InputSupportPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6InputSupportPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6NetworkPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6NetworkPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6NetworkPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6NetworkPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6NetworkPrivate CONFIG)"; then
                rlPass "find_package(Qt6NetworkPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6NetworkPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6OpenGLPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6OpenGLPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6OpenGLPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6OpenGLPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6OpenGLPrivate CONFIG)"; then
                rlPass "find_package(Qt6OpenGLPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6OpenGLPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6PrintSupportPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PrintSupportPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PrintSupportPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PrintSupportPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6PrintSupportPrivate CONFIG)"; then
                rlPass "find_package(Qt6PrintSupportPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PrintSupportPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6SqlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6SqlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6SqlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6SqlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6SqlPrivate CONFIG)"; then
                rlPass "find_package(Qt6SqlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6SqlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6TestInternalsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6TestInternalsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6TestInternalsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6TestInternalsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6TestInternalsPrivate CONFIG)"; then
                rlPass "find_package(Qt6TestInternalsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6TestInternalsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6TestPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6TestPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6TestPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6TestPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6TestPrivate CONFIG)"; then
                rlPass "find_package(Qt6TestPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6TestPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandClientPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandClientPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandClientPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandClientPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6WaylandClientPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandClientPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandClientPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandGlobalPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandGlobalPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandGlobalPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandGlobalPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6WaylandGlobalPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandGlobalPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandGlobalPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WidgetsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WidgetsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WidgetsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WidgetsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package Qt6WidgetsPrivate CONFIG)"; then
                rlPass "find_package(Qt6WidgetsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WidgetsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WlShellIntegrationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WlShellIntegrationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WlShellIntegrationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WlShellIntegrationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_17"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_17" 0 \
                "cmake configuration (find_package Qt6WlShellIntegrationPrivate CONFIG)"; then
                rlPass "find_package(Qt6WlShellIntegrationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WlShellIntegrationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6XcbQpaPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6XcbQpaPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6XcbQpaPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6XcbQpaPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_18"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_18" 0 \
                "cmake configuration (find_package Qt6XcbQpaPrivate CONFIG)"; then
                rlPass "find_package(Qt6XcbQpaPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6XcbQpaPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6XmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6XmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6XmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6XmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_19"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_19" 0 \
                "cmake configuration (find_package Qt6XmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6XmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6XmlPrivate CONFIG) verification failed"
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

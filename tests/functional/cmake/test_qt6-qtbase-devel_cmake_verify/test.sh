#!/bin/bash
# Functional test: qt6-qtbase-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtbase-devel"

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
            # --- find_package(Qt6) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)

message(STATUS "find_package(Qt6) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6 CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Qt6 CONFIG)"; then
                rlPass "find_package(Qt6 CONFIG) verification passed"
            else
                rlFail "find_package(Qt6 CONFIG) verification failed"
            fi

            # --- find_package(Qt6BuildInternals) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6BuildInternals REQUIRED CONFIG)

message(STATUS "find_package(Qt6BuildInternals) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6BuildInternals CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6BuildInternals CONFIG)"; then
                rlPass "find_package(Qt6BuildInternals CONFIG) verification passed"
            else
                rlFail "find_package(Qt6BuildInternals CONFIG) verification failed"
            fi

            # --- find_package(Qt6Concurrent) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Concurrent REQUIRED CONFIG)

message(STATUS "find_package(Qt6Concurrent) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Concurrent CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6Concurrent CONFIG)"; then
                rlPass "find_package(Qt6Concurrent CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Concurrent CONFIG) verification failed"
            fi

            # --- find_package(Qt6Core) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Core REQUIRED CONFIG)

message(STATUS "find_package(Qt6Core) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Core CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6Core CONFIG)"; then
                rlPass "find_package(Qt6Core CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Core CONFIG) verification failed"
            fi

            # --- find_package(Qt6CoreTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6CoreTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6CoreTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6CoreTools CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6CoreTools CONFIG)"; then
                rlPass "find_package(Qt6CoreTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6CoreTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6DBus) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6DBus REQUIRED CONFIG)

message(STATUS "find_package(Qt6DBus) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DBus CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6DBus CONFIG)"; then
                rlPass "find_package(Qt6DBus CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DBus CONFIG) verification failed"
            fi

            # --- find_package(Qt6DBusTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6DBusTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6DBusTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DBusTools CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6DBusTools CONFIG)"; then
                rlPass "find_package(Qt6DBusTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DBusTools CONFIG) verification failed"
            fi

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
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6Gui CONFIG)"; then
                rlPass "find_package(Qt6Gui CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Gui CONFIG) verification failed"
            fi

            # --- find_package(Qt6GuiTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6GuiTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6GuiTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6GuiTools CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6GuiTools CONFIG)"; then
                rlPass "find_package(Qt6GuiTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6GuiTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6HostInfo) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6HostInfo REQUIRED CONFIG)

message(STATUS "find_package(Qt6HostInfo) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6HostInfo CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6HostInfo CONFIG)"; then
                rlPass "find_package(Qt6HostInfo CONFIG) verification passed"
            else
                rlFail "find_package(Qt6HostInfo CONFIG) verification failed"
            fi

            # --- find_package(Qt6Network) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Network REQUIRED CONFIG)

message(STATUS "find_package(Qt6Network) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Network CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6Network CONFIG)"; then
                rlPass "find_package(Qt6Network CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Network CONFIG) verification failed"
            fi

            # --- find_package(Qt6OpenGL) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6OpenGL REQUIRED CONFIG)

message(STATUS "find_package(Qt6OpenGL) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6OpenGL CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6OpenGL CONFIG)"; then
                rlPass "find_package(Qt6OpenGL CONFIG) verification passed"
            else
                rlFail "find_package(Qt6OpenGL CONFIG) verification failed"
            fi

            # --- find_package(Qt6OpenGLWidgets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6OpenGLWidgets REQUIRED CONFIG)

message(STATUS "find_package(Qt6OpenGLWidgets) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6OpenGLWidgets CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6OpenGLWidgets CONFIG)"; then
                rlPass "find_package(Qt6OpenGLWidgets CONFIG) verification passed"
            else
                rlFail "find_package(Qt6OpenGLWidgets CONFIG) verification failed"
            fi

            # --- find_package(Qt6PrintSupport) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6PrintSupport REQUIRED CONFIG)

message(STATUS "find_package(Qt6PrintSupport) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PrintSupport CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6PrintSupport CONFIG)"; then
                rlPass "find_package(Qt6PrintSupport CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PrintSupport CONFIG) verification failed"
            fi

            # --- find_package(Qt6Sql) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Sql REQUIRED CONFIG)

message(STATUS "find_package(Qt6Sql) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Sql CONFIG) ..."
            rm -rf "$TmpDir/build_52"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_52" 0 \
                "cmake configuration (find_package Qt6Sql CONFIG)"; then
                rlPass "find_package(Qt6Sql CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Sql CONFIG) verification failed"
            fi

            # --- find_package(Qt6Test) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Test REQUIRED CONFIG)

message(STATUS "find_package(Qt6Test) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Test CONFIG) ..."
            rm -rf "$TmpDir/build_53"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_53" 0 \
                "cmake configuration (find_package Qt6Test CONFIG)"; then
                rlPass "find_package(Qt6Test CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Test CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandClient) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WaylandClient REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandClient) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandClient CONFIG) ..."
            rm -rf "$TmpDir/build_55"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_55" 0 \
                "cmake configuration (find_package Qt6WaylandClient CONFIG)"; then
                rlPass "find_package(Qt6WaylandClient CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandClient CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandScannerTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandScannerTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandScannerTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandScannerTools CONFIG) ..."
            rm -rf "$TmpDir/build_56"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_56" 0 \
                "cmake configuration (find_package Qt6WaylandScannerTools CONFIG)"; then
                rlPass "find_package(Qt6WaylandScannerTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandScannerTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6Widgets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Widgets REQUIRED CONFIG)

message(STATUS "find_package(Qt6Widgets) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Widgets CONFIG) ..."
            rm -rf "$TmpDir/build_57"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_57" 0 \
                "cmake configuration (find_package Qt6Widgets CONFIG)"; then
                rlPass "find_package(Qt6Widgets CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Widgets CONFIG) verification failed"
            fi

            # --- find_package(Qt6WidgetsTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WidgetsTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6WidgetsTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WidgetsTools CONFIG) ..."
            rm -rf "$TmpDir/build_58"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_58" 0 \
                "cmake configuration (find_package Qt6WidgetsTools CONFIG)"; then
                rlPass "find_package(Qt6WidgetsTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WidgetsTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6Xml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Xml REQUIRED CONFIG)

message(STATUS "find_package(Qt6Xml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Xml CONFIG) ..."
            rm -rf "$TmpDir/build_59"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_59" 0 \
                "cmake configuration (find_package Qt6Xml CONFIG)"; then
                rlPass "find_package(Qt6Xml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Xml CONFIG) verification failed"
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

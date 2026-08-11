#!/bin/bash
# Functional test: freerdp-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="freerdp-devel"

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
            # --- find_package(FreeRDP) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FreeRDP REQUIRED CONFIG)

message(STATUS "find_package(FreeRDP) succeeded")
EOF

            rlLogInfo "Verifying find_package(FreeRDP CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package FreeRDP CONFIG)"; then
                rlPass "find_package(FreeRDP CONFIG) verification passed"
            else
                rlFail "find_package(FreeRDP CONFIG) verification failed"
            fi

            # --- find_package(FreeRDP-Client) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FreeRDP-Client REQUIRED CONFIG)

message(STATUS "find_package(FreeRDP-Client) succeeded")
EOF

            rlLogInfo "Verifying find_package(FreeRDP-Client CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package FreeRDP-Client CONFIG)"; then
                rlPass "find_package(FreeRDP-Client CONFIG) verification passed"
            else
                rlFail "find_package(FreeRDP-Client CONFIG) verification failed"
            fi

            # --- find_package(FreeRDP-Proxy) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FreeRDP-Proxy REQUIRED CONFIG)

message(STATUS "find_package(FreeRDP-Proxy) succeeded")
EOF

            rlLogInfo "Verifying find_package(FreeRDP-Proxy CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package FreeRDP-Proxy CONFIG)"; then
                rlPass "find_package(FreeRDP-Proxy CONFIG) verification passed"
            else
                rlFail "find_package(FreeRDP-Proxy CONFIG) verification failed"
            fi

            # --- find_package(FreeRDP-Server) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FreeRDP-Server REQUIRED CONFIG)

message(STATUS "find_package(FreeRDP-Server) succeeded")
EOF

            rlLogInfo "Verifying find_package(FreeRDP-Server CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package FreeRDP-Server CONFIG)"; then
                rlPass "find_package(FreeRDP-Server CONFIG) verification passed"
            else
                rlFail "find_package(FreeRDP-Server CONFIG) verification failed"
            fi

            # --- find_package(FreeRDP-Shadow) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(FreeRDP-Shadow REQUIRED CONFIG)

message(STATUS "find_package(FreeRDP-Shadow) succeeded")
EOF

            rlLogInfo "Verifying find_package(FreeRDP-Shadow CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package FreeRDP-Shadow CONFIG)"; then
                rlPass "find_package(FreeRDP-Shadow CONFIG) verification passed"
            else
                rlFail "find_package(FreeRDP-Shadow CONFIG) verification failed"
            fi

            # --- find_package(WinPR) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(WinPR REQUIRED CONFIG)

message(STATUS "find_package(WinPR) succeeded")
EOF

            rlLogInfo "Verifying find_package(WinPR CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package WinPR CONFIG)"; then
                rlPass "find_package(WinPR CONFIG) verification passed"
            else
                rlFail "find_package(WinPR CONFIG) verification failed"
            fi

            # --- find_package(WinPR-tools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(WinPR-tools REQUIRED CONFIG)

message(STATUS "find_package(WinPR-tools) succeeded")
EOF

            rlLogInfo "Verifying find_package(WinPR-tools CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package WinPR-tools CONFIG)"; then
                rlPass "find_package(WinPR-tools CONFIG) verification passed"
            else
                rlFail "find_package(WinPR-tools CONFIG) verification failed"
            fi

            # --- find_package(rdtk) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(rdtk REQUIRED CONFIG)

message(STATUS "find_package(rdtk) succeeded")
EOF

            rlLogInfo "Verifying find_package(rdtk CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package rdtk CONFIG)"; then
                rlPass "find_package(rdtk CONFIG) verification passed"
            else
                rlFail "find_package(rdtk CONFIG) verification failed"
            fi

            # --- find_package(uwac) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(uwac REQUIRED CONFIG)

message(STATUS "find_package(uwac) succeeded")
EOF

            rlLogInfo "Verifying find_package(uwac CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package uwac CONFIG)"; then
                rlPass "find_package(uwac CONFIG) verification passed"
            else
                rlFail "find_package(uwac CONFIG) verification failed"
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

#!/bin/bash
# Functional test: qt6-qtwebengine-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtwebengine-devel"

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

            # --- find_package(Qt6Designer) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Designer REQUIRED CONFIG)

message(STATUS "find_package(Qt6Designer) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Designer CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6Designer CONFIG)"; then
                rlPass "find_package(Qt6Designer CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Designer CONFIG) verification failed"
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
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6Gui CONFIG)"; then
                rlPass "find_package(Qt6Gui CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Gui CONFIG) verification failed"
            fi

            # --- find_package(Qt6Pdf) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Pdf REQUIRED CONFIG)

message(STATUS "find_package(Qt6Pdf) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Pdf CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6Pdf CONFIG)"; then
                rlPass "find_package(Qt6Pdf CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Pdf CONFIG) verification failed"
            fi

            # --- find_package(Qt6PdfPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PdfPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PdfPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PdfPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6PdfPrivate CONFIG)"; then
                rlPass "find_package(Qt6PdfPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PdfPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6PdfQuick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6PdfQuick REQUIRED CONFIG)

message(STATUS "find_package(Qt6PdfQuick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PdfQuick CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6PdfQuick CONFIG)"; then
                rlPass "find_package(Qt6PdfQuick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PdfQuick CONFIG) verification failed"
            fi

            # --- find_package(Qt6PdfQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PdfQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PdfQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PdfQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6PdfQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6PdfQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PdfQuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6PdfWidgets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6PdfWidgets REQUIRED CONFIG)

message(STATUS "find_package(Qt6PdfWidgets) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PdfWidgets CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6PdfWidgets CONFIG)"; then
                rlPass "find_package(Qt6PdfWidgets CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PdfWidgets CONFIG) verification failed"
            fi

            # --- find_package(Qt6PdfWidgetsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PdfWidgetsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PdfWidgetsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PdfWidgetsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6PdfWidgetsPrivate CONFIG)"; then
                rlPass "find_package(Qt6PdfWidgetsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PdfWidgetsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineCore) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WebEngineCore REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineCore) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineCore CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6WebEngineCore CONFIG)"; then
                rlPass "find_package(Qt6WebEngineCore CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineCore CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineCorePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WebEngineCorePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineCorePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineCorePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6WebEngineCorePrivate CONFIG)"; then
                rlPass "find_package(Qt6WebEngineCorePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineCorePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineCoreTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WebEngineCoreTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineCoreTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineCoreTools CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6WebEngineCoreTools CONFIG)"; then
                rlPass "find_package(Qt6WebEngineCoreTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineCoreTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineQuick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WebEngineQuick REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineQuick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineQuick CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6WebEngineQuick CONFIG)"; then
                rlPass "find_package(Qt6WebEngineQuick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineQuick CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineQuickDelegatesQml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WebEngineQuickDelegatesQml REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineQuickDelegatesQml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineQuickDelegatesQml CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package Qt6WebEngineQuickDelegatesQml CONFIG)"; then
                rlPass "find_package(Qt6WebEngineQuickDelegatesQml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineQuickDelegatesQml CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WebEngineQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_17"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_17" 0 \
                "cmake configuration (find_package Qt6WebEngineQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6WebEngineQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineQuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineWidgets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WebEngineWidgets REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineWidgets) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineWidgets CONFIG) ..."
            rm -rf "$TmpDir/build_18"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_18" 0 \
                "cmake configuration (find_package Qt6WebEngineWidgets CONFIG)"; then
                rlPass "find_package(Qt6WebEngineWidgets CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineWidgets CONFIG) verification failed"
            fi

            # --- find_package(Qt6WebEngineWidgetsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WebEngineWidgetsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WebEngineWidgetsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WebEngineWidgetsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_19"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_19" 0 \
                "cmake configuration (find_package Qt6WebEngineWidgetsPrivate CONFIG)"; then
                rlPass "find_package(Qt6WebEngineWidgetsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WebEngineWidgetsPrivate CONFIG) verification failed"
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

#!/bin/bash
# Functional test: qt6-qttools-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qttools-devel"

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
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Qt6Designer CONFIG)"; then
                rlPass "find_package(Qt6Designer CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Designer CONFIG) verification failed"
            fi

            # --- find_package(Qt6DesignerComponentsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6DesignerComponentsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6DesignerComponentsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DesignerComponentsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6DesignerComponentsPrivate CONFIG)"; then
                rlPass "find_package(Qt6DesignerComponentsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DesignerComponentsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6DesignerPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6DesignerPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6DesignerPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6DesignerPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6DesignerPrivate CONFIG)"; then
                rlPass "find_package(Qt6DesignerPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6DesignerPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Help) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Help REQUIRED CONFIG)

message(STATUS "find_package(Qt6Help) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Help CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6Help CONFIG)"; then
                rlPass "find_package(Qt6Help CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Help CONFIG) verification failed"
            fi

            # --- find_package(Qt6HelpPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6HelpPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6HelpPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6HelpPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6HelpPrivate CONFIG)"; then
                rlPass "find_package(Qt6HelpPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6HelpPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Linguist) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Linguist REQUIRED CONFIG)

message(STATUS "find_package(Qt6Linguist) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Linguist CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6Linguist CONFIG)"; then
                rlPass "find_package(Qt6Linguist CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Linguist CONFIG) verification failed"
            fi

            # --- find_package(Qt6LinguistTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LinguistTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6LinguistTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LinguistTools CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6LinguistTools CONFIG)"; then
                rlPass "find_package(Qt6LinguistTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LinguistTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6QDocCatchConversionsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QDocCatchConversionsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QDocCatchConversionsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QDocCatchConversionsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6QDocCatchConversionsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QDocCatchConversionsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QDocCatchConversionsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QDocCatchGeneratorsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QDocCatchGeneratorsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QDocCatchGeneratorsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QDocCatchGeneratorsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6QDocCatchGeneratorsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QDocCatchGeneratorsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QDocCatchGeneratorsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QDocCatchPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QDocCatchPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QDocCatchPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QDocCatchPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6QDocCatchPrivate CONFIG)"; then
                rlPass "find_package(Qt6QDocCatchPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QDocCatchPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Tools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Tools REQUIRED CONFIG)

message(STATUS "find_package(Qt6Tools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Tools CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6Tools CONFIG)"; then
                rlPass "find_package(Qt6Tools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Tools CONFIG) verification failed"
            fi

            # --- find_package(Qt6ToolsTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ToolsTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6ToolsTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ToolsTools CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6ToolsTools CONFIG)"; then
                rlPass "find_package(Qt6ToolsTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ToolsTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6UiTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6UiTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6UiTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6UiTools CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6UiTools CONFIG)"; then
                rlPass "find_package(Qt6UiTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6UiTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6UiToolsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6UiToolsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6UiToolsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6UiToolsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6UiToolsPrivate CONFIG)"; then
                rlPass "find_package(Qt6UiToolsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6UiToolsPrivate CONFIG) verification failed"
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

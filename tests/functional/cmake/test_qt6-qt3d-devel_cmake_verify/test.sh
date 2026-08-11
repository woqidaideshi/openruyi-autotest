#!/bin/bash
# Functional test: qt6-qt3d-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qt3d-devel"

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

            # --- find_package(Qt63DAnimation) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DAnimation REQUIRED CONFIG)

message(STATUS "find_package(Qt63DAnimation) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DAnimation CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt63DAnimation CONFIG)"; then
                rlPass "find_package(Qt63DAnimation CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DAnimation CONFIG) verification failed"
            fi

            # --- find_package(Qt63DAnimationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DAnimationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DAnimationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DAnimationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt63DAnimationPrivate CONFIG)"; then
                rlPass "find_package(Qt63DAnimationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DAnimationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DCore) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DCore REQUIRED CONFIG)

message(STATUS "find_package(Qt63DCore) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DCore CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt63DCore CONFIG)"; then
                rlPass "find_package(Qt63DCore CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DCore CONFIG) verification failed"
            fi

            # --- find_package(Qt63DCorePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DCorePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DCorePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DCorePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt63DCorePrivate CONFIG)"; then
                rlPass "find_package(Qt63DCorePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DCorePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DExtras) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DExtras REQUIRED CONFIG)

message(STATUS "find_package(Qt63DExtras) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DExtras CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt63DExtras CONFIG)"; then
                rlPass "find_package(Qt63DExtras CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DExtras CONFIG) verification failed"
            fi

            # --- find_package(Qt63DExtrasPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DExtrasPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DExtrasPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DExtrasPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt63DExtrasPrivate CONFIG)"; then
                rlPass "find_package(Qt63DExtrasPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DExtrasPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DInput) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DInput REQUIRED CONFIG)

message(STATUS "find_package(Qt63DInput) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DInput CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt63DInput CONFIG)"; then
                rlPass "find_package(Qt63DInput CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DInput CONFIG) verification failed"
            fi

            # --- find_package(Qt63DInputPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DInputPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DInputPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DInputPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt63DInputPrivate CONFIG)"; then
                rlPass "find_package(Qt63DInputPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DInputPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DLogic) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DLogic REQUIRED CONFIG)

message(STATUS "find_package(Qt63DLogic) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DLogic CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt63DLogic CONFIG)"; then
                rlPass "find_package(Qt63DLogic CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DLogic CONFIG) verification failed"
            fi

            # --- find_package(Qt63DLogicPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DLogicPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DLogicPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DLogicPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt63DLogicPrivate CONFIG)"; then
                rlPass "find_package(Qt63DLogicPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DLogicPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuick REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuick CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt63DQuick CONFIG)"; then
                rlPass "find_package(Qt63DQuick CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuick CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickAnimation) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickAnimation REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickAnimation) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickAnimation CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt63DQuickAnimation CONFIG)"; then
                rlPass "find_package(Qt63DQuickAnimation CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickAnimation CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickAnimationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickAnimationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickAnimationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickAnimationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt63DQuickAnimationPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickAnimationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickAnimationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickExtras) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickExtras REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickExtras) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickExtras CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt63DQuickExtras CONFIG)"; then
                rlPass "find_package(Qt63DQuickExtras CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickExtras CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickExtrasPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickExtrasPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickExtrasPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickExtrasPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package Qt63DQuickExtrasPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickExtrasPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickExtrasPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickInput) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickInput REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickInput) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickInput CONFIG) ..."
            rm -rf "$TmpDir/build_17"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_17" 0 \
                "cmake configuration (find_package Qt63DQuickInput CONFIG)"; then
                rlPass "find_package(Qt63DQuickInput CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickInput CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickInputPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickInputPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickInputPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickInputPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_18"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_18" 0 \
                "cmake configuration (find_package Qt63DQuickInputPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickInputPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickInputPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickLogic) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickLogic REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickLogic) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickLogic CONFIG) ..."
            rm -rf "$TmpDir/build_19"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_19" 0 \
                "cmake configuration (find_package Qt63DQuickLogic CONFIG)"; then
                rlPass "find_package(Qt63DQuickLogic CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickLogic CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickLogicPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickLogicPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickLogicPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickLogicPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_20"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_20" 0 \
                "cmake configuration (find_package Qt63DQuickLogicPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickLogicPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickLogicPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_21"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_21" 0 \
                "cmake configuration (find_package Qt63DQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickRender) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickRender REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickRender) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickRender CONFIG) ..."
            rm -rf "$TmpDir/build_22"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_22" 0 \
                "cmake configuration (find_package Qt63DQuickRender CONFIG)"; then
                rlPass "find_package(Qt63DQuickRender CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickRender CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickRenderPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickRenderPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickRenderPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickRenderPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_23"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_23" 0 \
                "cmake configuration (find_package Qt63DQuickRenderPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickRenderPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickRenderPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickScene2D) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickScene2D REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickScene2D) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickScene2D CONFIG) ..."
            rm -rf "$TmpDir/build_24"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_24" 0 \
                "cmake configuration (find_package Qt63DQuickScene2D CONFIG)"; then
                rlPass "find_package(Qt63DQuickScene2D CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickScene2D CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickScene2DPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickScene2DPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickScene2DPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickScene2DPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_25"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_25" 0 \
                "cmake configuration (find_package Qt63DQuickScene2DPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickScene2DPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickScene2DPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickScene3D) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DQuickScene3D REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickScene3D) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickScene3D CONFIG) ..."
            rm -rf "$TmpDir/build_26"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_26" 0 \
                "cmake configuration (find_package Qt63DQuickScene3D CONFIG)"; then
                rlPass "find_package(Qt63DQuickScene3D CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickScene3D CONFIG) verification failed"
            fi

            # --- find_package(Qt63DQuickScene3DPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DQuickScene3DPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DQuickScene3DPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DQuickScene3DPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_27"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_27" 0 \
                "cmake configuration (find_package Qt63DQuickScene3DPrivate CONFIG)"; then
                rlPass "find_package(Qt63DQuickScene3DPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DQuickScene3DPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt63DRender) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt63DRender REQUIRED CONFIG)

message(STATUS "find_package(Qt63DRender) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DRender CONFIG) ..."
            rm -rf "$TmpDir/build_28"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_28" 0 \
                "cmake configuration (find_package Qt63DRender CONFIG)"; then
                rlPass "find_package(Qt63DRender CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DRender CONFIG) verification failed"
            fi

            # --- find_package(Qt63DRenderPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt63DRenderPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt63DRenderPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt63DRenderPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_29"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_29" 0 \
                "cmake configuration (find_package Qt63DRenderPrivate CONFIG)"; then
                rlPass "find_package(Qt63DRenderPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt63DRenderPrivate CONFIG) verification failed"
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

#!/bin/bash
# Functional test: qt6-qtwayland-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtwayland-devel"

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
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6WaylandClient CONFIG)"; then
                rlPass "find_package(Qt6WaylandClient CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandClient CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandClientFeaturesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandClientFeaturesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandClientFeaturesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandClientFeaturesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6WaylandClientFeaturesPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandClientFeaturesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandClientFeaturesPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositor) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WaylandCompositor REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositor) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositor CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6WaylandCompositor CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositor CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositor CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorIviapplication) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WaylandCompositorIviapplication REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorIviapplication) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorIviapplication CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorIviapplication CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorIviapplication CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorIviapplication CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorIviapplicationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandCompositorIviapplicationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorIviapplicationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorIviapplicationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorIviapplicationPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorIviapplicationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorIviapplicationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorPresentationTime) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WaylandCompositorPresentationTime REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorPresentationTime) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorPresentationTime CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorPresentationTime CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorPresentationTime CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorPresentationTime CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorPresentationTimePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandCompositorPresentationTimePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorPresentationTimePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorPresentationTimePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorPresentationTimePrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorPresentationTimePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorPresentationTimePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandCompositorPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_18"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_18" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorQtShell) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandCompositorQtShell CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH)

message(STATUS "find_package(Qt6WaylandCompositorQtShell) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorQtShell CONFIG) ..."
            rm -rf "$TmpDir/build_19"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_19" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorQtShell CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorQtShell CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorQtShell CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorWLShell) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WaylandCompositorWLShell REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorWLShell) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorWLShell CONFIG) ..."
            rm -rf "$TmpDir/build_20"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_20" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorWLShell CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorWLShell CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorWLShell CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorWLShellPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandCompositorWLShellPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorWLShellPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorWLShellPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_21"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_21" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorWLShellPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorWLShellPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorWLShellPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorXdgShell) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6WaylandCompositorXdgShell REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorXdgShell) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorXdgShell CONFIG) ..."
            rm -rf "$TmpDir/build_23"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_23" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorXdgShell CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorXdgShell CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorXdgShell CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandCompositorXdgShellPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandCompositorXdgShellPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandCompositorXdgShellPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandCompositorXdgShellPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_24"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_24" 0 \
                "cmake configuration (find_package Qt6WaylandCompositorXdgShellPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandCompositorXdgShellPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandCompositorXdgShellPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandEglCompositorHwIntegrationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandEglCompositorHwIntegrationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6WaylandEglCompositorHwIntegrationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandEglCompositorHwIntegrationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_26"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_26" 0 \
                "cmake configuration (find_package Qt6WaylandEglCompositorHwIntegrationPrivate CONFIG)"; then
                rlPass "find_package(Qt6WaylandEglCompositorHwIntegrationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandEglCompositorHwIntegrationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandTextureSharing) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandTextureSharing CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH)

message(STATUS "find_package(Qt6WaylandTextureSharing) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandTextureSharing CONFIG) ..."
            rm -rf "$TmpDir/build_27"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_27" 0 \
                "cmake configuration (find_package Qt6WaylandTextureSharing CONFIG)"; then
                rlPass "find_package(Qt6WaylandTextureSharing CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandTextureSharing CONFIG) verification failed"
            fi

            # --- find_package(Qt6WaylandTextureSharingExtension) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6WaylandTextureSharingExtension CONFIG
  PATHS /usr/lib64/cmake/Qt6Qml/QmlPlugins
  NO_DEFAULT_PATH)

message(STATUS "find_package(Qt6WaylandTextureSharingExtension) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6WaylandTextureSharingExtension CONFIG) ..."
            rm -rf "$TmpDir/build_28"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_28" 0 \
                "cmake configuration (find_package Qt6WaylandTextureSharingExtension CONFIG)"; then
                rlPass "find_package(Qt6WaylandTextureSharingExtension CONFIG) verification passed"
            else
                rlFail "find_package(Qt6WaylandTextureSharingExtension CONFIG) verification failed"
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

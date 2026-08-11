#!/bin/bash
# Functional test: qt6-qtquick3d-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtquick3d-devel"

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

            # --- find_package(Qt6BundledOpenXR) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6BundledOpenXR REQUIRED CONFIG)

message(STATUS "find_package(Qt6BundledOpenXR) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6BundledOpenXR CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6BundledOpenXR CONFIG)"; then
                rlPass "find_package(Qt6BundledOpenXR CONFIG) verification passed"
            else
                rlFail "find_package(Qt6BundledOpenXR CONFIG) verification failed"
            fi

            # --- find_package(Qt6Qml) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Qml REQUIRED CONFIG)

message(STATUS "find_package(Qt6Qml) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Qml CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6Qml CONFIG)"; then
                rlPass "find_package(Qt6Qml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Qml CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3D) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3D REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3D) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3D CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6Quick3D CONFIG)"; then
                rlPass "find_package(Qt6Quick3D CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3D CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DAssetImport) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DAssetImport REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DAssetImport) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DAssetImport CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6Quick3DAssetImport CONFIG)"; then
                rlPass "find_package(Qt6Quick3DAssetImport CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DAssetImport CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DAssetImportPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DAssetImportPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DAssetImportPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DAssetImportPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6Quick3DAssetImportPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DAssetImportPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DAssetImportPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DAssetUtils) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DAssetUtils REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DAssetUtils) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DAssetUtils CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6Quick3DAssetUtils CONFIG)"; then
                rlPass "find_package(Qt6Quick3DAssetUtils CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DAssetUtils CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DAssetUtilsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DAssetUtilsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DAssetUtilsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DAssetUtilsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6Quick3DAssetUtilsPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DAssetUtilsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DAssetUtilsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DEffects) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DEffects REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DEffects) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DEffects CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6Quick3DEffects CONFIG)"; then
                rlPass "find_package(Qt6Quick3DEffects CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DEffects CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DGlslParserPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DGlslParserPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DGlslParserPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DGlslParserPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6Quick3DGlslParserPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DGlslParserPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DGlslParserPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DHelpers) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DHelpers REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DHelpers) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DHelpers CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6Quick3DHelpers CONFIG)"; then
                rlPass "find_package(Qt6Quick3DHelpers CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DHelpers CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DHelpersImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DHelpersImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DHelpersImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DHelpersImpl CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6Quick3DHelpersImpl CONFIG)"; then
                rlPass "find_package(Qt6Quick3DHelpersImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DHelpersImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DHelpersImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DHelpersImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DHelpersImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DHelpersImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6Quick3DHelpersImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DHelpersImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DHelpersImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DHelpersPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DHelpersPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DHelpersPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DHelpersPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6Quick3DHelpersPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DHelpersPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DHelpersPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DIblBaker) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DIblBaker REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DIblBaker) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DIblBaker CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package Qt6Quick3DIblBaker CONFIG)"; then
                rlPass "find_package(Qt6Quick3DIblBaker CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DIblBaker CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DIblBakerPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DIblBakerPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DIblBakerPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DIblBakerPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_17"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_17" 0 \
                "cmake configuration (find_package Qt6Quick3DIblBakerPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DIblBakerPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DIblBakerPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DParticleEffects) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DParticleEffects REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DParticleEffects) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DParticleEffects CONFIG) ..."
            rm -rf "$TmpDir/build_18"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_18" 0 \
                "cmake configuration (find_package Qt6Quick3DParticleEffects CONFIG)"; then
                rlPass "find_package(Qt6Quick3DParticleEffects CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DParticleEffects CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DParticles) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DParticles REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DParticles) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DParticles CONFIG) ..."
            rm -rf "$TmpDir/build_19"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_19" 0 \
                "cmake configuration (find_package Qt6Quick3DParticles CONFIG)"; then
                rlPass "find_package(Qt6Quick3DParticles CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DParticles CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DParticlesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DParticlesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DParticlesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DParticlesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_20"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_20" 0 \
                "cmake configuration (find_package Qt6Quick3DParticlesPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DParticlesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DParticlesPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_21"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_21" 0 \
                "cmake configuration (find_package Qt6Quick3DPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DRuntimeRender) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DRuntimeRender REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DRuntimeRender) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DRuntimeRender CONFIG) ..."
            rm -rf "$TmpDir/build_22"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_22" 0 \
                "cmake configuration (find_package Qt6Quick3DRuntimeRender CONFIG)"; then
                rlPass "find_package(Qt6Quick3DRuntimeRender CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DRuntimeRender CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DRuntimeRenderPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DRuntimeRenderPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DRuntimeRenderPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DRuntimeRenderPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_23"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_23" 0 \
                "cmake configuration (find_package Qt6Quick3DRuntimeRenderPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DRuntimeRenderPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DRuntimeRenderPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DTools CONFIG) ..."
            rm -rf "$TmpDir/build_24"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_24" 0 \
                "cmake configuration (find_package Qt6Quick3DTools CONFIG)"; then
                rlPass "find_package(Qt6Quick3DTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DUtils) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DUtils REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DUtils) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DUtils CONFIG) ..."
            rm -rf "$TmpDir/build_25"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_25" 0 \
                "cmake configuration (find_package Qt6Quick3DUtils CONFIG)"; then
                rlPass "find_package(Qt6Quick3DUtils CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DUtils CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DUtilsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DUtilsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DUtilsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DUtilsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_26"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_26" 0 \
                "cmake configuration (find_package Qt6Quick3DUtilsPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DUtilsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DUtilsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DXr) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick3DXr REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DXr) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DXr CONFIG) ..."
            rm -rf "$TmpDir/build_27"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_27" 0 \
                "cmake configuration (find_package Qt6Quick3DXr CONFIG)"; then
                rlPass "find_package(Qt6Quick3DXr CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DXr CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick3DXrPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6Quick3DXrPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick3DXrPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick3DXrPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_28"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_28" 0 \
                "cmake configuration (find_package Qt6Quick3DXrPrivate CONFIG)"; then
                rlPass "find_package(Qt6Quick3DXrPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick3DXrPrivate CONFIG) verification failed"
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

#!/bin/bash
# Functional test: qt6-qtdeclarative-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtdeclarative-devel"

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

            # --- find_package(Qt6LabsAnimation) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsAnimation REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsAnimation) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsAnimation CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6LabsAnimation CONFIG)"; then
                rlPass "find_package(Qt6LabsAnimation CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsAnimation CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsAnimationPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsAnimationPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsAnimationPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsAnimationPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6LabsAnimationPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsAnimationPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsAnimationPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsFolderListModel) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsFolderListModel REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsFolderListModel) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsFolderListModel CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6LabsFolderListModel CONFIG)"; then
                rlPass "find_package(Qt6LabsFolderListModel CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsFolderListModel CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsFolderListModelPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsFolderListModelPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsFolderListModelPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsFolderListModelPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6LabsFolderListModelPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsFolderListModelPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsFolderListModelPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsPlatform) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsPlatform REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsPlatform) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsPlatform CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6LabsPlatform CONFIG)"; then
                rlPass "find_package(Qt6LabsPlatform CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsPlatform CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsPlatformPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsPlatformPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsPlatformPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsPlatformPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6LabsPlatformPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsPlatformPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsPlatformPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsQmlModels) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsQmlModels REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsQmlModels) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsQmlModels CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6LabsQmlModels CONFIG)"; then
                rlPass "find_package(Qt6LabsQmlModels CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsQmlModels CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsQmlModelsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsQmlModelsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsQmlModelsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsQmlModelsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6LabsQmlModelsPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsQmlModelsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsQmlModelsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsSettings) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsSettings REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsSettings) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsSettings CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6LabsSettings CONFIG)"; then
                rlPass "find_package(Qt6LabsSettings CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsSettings CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsSettingsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsSettingsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsSettingsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsSettingsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6LabsSettingsPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsSettingsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsSettingsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsSharedImage) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsSharedImage REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsSharedImage) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsSharedImage CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6LabsSharedImage CONFIG)"; then
                rlPass "find_package(Qt6LabsSharedImage CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsSharedImage CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsSharedImagePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsSharedImagePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsSharedImagePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsSharedImagePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6LabsSharedImagePrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsSharedImagePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsSharedImagePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsSynchronizer) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsSynchronizer REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsSynchronizer) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsSynchronizer CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6LabsSynchronizer CONFIG)"; then
                rlPass "find_package(Qt6LabsSynchronizer CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsSynchronizer CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsSynchronizerPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsSynchronizerPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsSynchronizerPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsSynchronizerPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6LabsSynchronizerPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsSynchronizerPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsSynchronizerPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsWavefrontMesh) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LabsWavefrontMesh REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsWavefrontMesh) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsWavefrontMesh CONFIG) ..."
            rm -rf "$TmpDir/build_17"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_17" 0 \
                "cmake configuration (find_package Qt6LabsWavefrontMesh CONFIG)"; then
                rlPass "find_package(Qt6LabsWavefrontMesh CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsWavefrontMesh CONFIG) verification failed"
            fi

            # --- find_package(Qt6LabsWavefrontMeshPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LabsWavefrontMeshPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LabsWavefrontMeshPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LabsWavefrontMeshPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_18"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_18" 0 \
                "cmake configuration (find_package Qt6LabsWavefrontMeshPrivate CONFIG)"; then
                rlPass "find_package(Qt6LabsWavefrontMeshPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LabsWavefrontMeshPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6PacketProtocolPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6PacketProtocolPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6PacketProtocolPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6PacketProtocolPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_19"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_19" 0 \
                "cmake configuration (find_package Qt6PacketProtocolPrivate CONFIG)"; then
                rlPass "find_package(Qt6PacketProtocolPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6PacketProtocolPrivate CONFIG) verification failed"
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
            rm -rf "$TmpDir/build_31"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_31" 0 \
                "cmake configuration (find_package Qt6Qml CONFIG)"; then
                rlPass "find_package(Qt6Qml CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Qml CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlCompiler) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlCompiler REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlCompiler) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlCompiler CONFIG) ..."
            rm -rf "$TmpDir/build_32"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_32" 0 \
                "cmake configuration (find_package Qt6QmlCompiler CONFIG)"; then
                rlPass "find_package(Qt6QmlCompiler CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlCompiler CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlCompilerPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlCompilerPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlCompilerPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlCompilerPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_33"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_33" 0 \
                "cmake configuration (find_package Qt6QmlCompilerPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlCompilerPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlCompilerPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlCore) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlCore REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlCore) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlCore CONFIG) ..."
            rm -rf "$TmpDir/build_34"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_34" 0 \
                "cmake configuration (find_package Qt6QmlCore CONFIG)"; then
                rlPass "find_package(Qt6QmlCore CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlCore CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlCorePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlCorePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlCorePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlCorePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_35"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_35" 0 \
                "cmake configuration (find_package Qt6QmlCorePrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlCorePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlCorePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlDebugPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlDebugPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlDebugPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlDebugPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_36"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_36" 0 \
                "cmake configuration (find_package Qt6QmlDebugPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlDebugPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlDebugPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlDomPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlDomPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlDomPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlDomPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_37"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_37" 0 \
                "cmake configuration (find_package Qt6QmlDomPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlDomPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlDomPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlFormatPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlFormatPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlFormatPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlFormatPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_38"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_38" 0 \
                "cmake configuration (find_package Qt6QmlFormatPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlFormatPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlFormatPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlImportScanner) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlImportScanner REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlImportScanner) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlImportScanner CONFIG) ..."
            rm -rf "$TmpDir/build_39"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_39" 0 \
                "cmake configuration (find_package Qt6QmlImportScanner CONFIG)"; then
                rlPass "find_package(Qt6QmlImportScanner CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlImportScanner CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlIntegration) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlIntegration REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlIntegration) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlIntegration CONFIG) ..."
            rm -rf "$TmpDir/build_40"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_40" 0 \
                "cmake configuration (find_package Qt6QmlIntegration CONFIG)"; then
                rlPass "find_package(Qt6QmlIntegration CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlIntegration CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlLSPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlLSPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlLSPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlLSPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_41"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_41" 0 \
                "cmake configuration (find_package Qt6QmlLSPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlLSPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlLSPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlLocalStorage) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlLocalStorage REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlLocalStorage) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlLocalStorage CONFIG) ..."
            rm -rf "$TmpDir/build_45"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_45" 0 \
                "cmake configuration (find_package Qt6QmlLocalStorage CONFIG)"; then
                rlPass "find_package(Qt6QmlLocalStorage CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlLocalStorage CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlLocalStoragePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlLocalStoragePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlLocalStoragePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlLocalStoragePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_46"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_46" 0 \
                "cmake configuration (find_package Qt6QmlLocalStoragePrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlLocalStoragePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlLocalStoragePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlMeta) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlMeta REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlMeta) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlMeta CONFIG) ..."
            rm -rf "$TmpDir/build_47"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_47" 0 \
                "cmake configuration (find_package Qt6QmlMeta CONFIG)"; then
                rlPass "find_package(Qt6QmlMeta CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlMeta CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlMetaPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlMetaPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlMetaPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlMetaPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_48"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_48" 0 \
                "cmake configuration (find_package Qt6QmlMetaPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlMetaPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlMetaPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlModels) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlModels REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlModels) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlModels CONFIG) ..."
            rm -rf "$TmpDir/build_49"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_49" 0 \
                "cmake configuration (find_package Qt6QmlModels CONFIG)"; then
                rlPass "find_package(Qt6QmlModels CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlModels CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlModelsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlModelsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlModelsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlModelsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_50"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_50" 0 \
                "cmake configuration (find_package Qt6QmlModelsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlModelsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlModelsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlNetwork) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlNetwork REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlNetwork) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlNetwork CONFIG) ..."
            rm -rf "$TmpDir/build_51"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_51" 0 \
                "cmake configuration (find_package Qt6QmlNetwork CONFIG)"; then
                rlPass "find_package(Qt6QmlNetwork CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlNetwork CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlNetworkPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlNetworkPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlNetworkPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlNetworkPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_52"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_52" 0 \
                "cmake configuration (find_package Qt6QmlNetworkPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlNetworkPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlNetworkPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_54"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_54" 0 \
                "cmake configuration (find_package Qt6QmlPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlToolingSettingsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlToolingSettingsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlToolingSettingsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlToolingSettingsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_55"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_55" 0 \
                "cmake configuration (find_package Qt6QmlToolingSettingsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlToolingSettingsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlToolingSettingsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlTools CONFIG) ..."
            rm -rf "$TmpDir/build_56"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_56" 0 \
                "cmake configuration (find_package Qt6QmlTools CONFIG)"; then
                rlPass "find_package(Qt6QmlTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlTypeRegistrarPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlTypeRegistrarPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlTypeRegistrarPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlTypeRegistrarPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_57"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_57" 0 \
                "cmake configuration (find_package Qt6QmlTypeRegistrarPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlTypeRegistrarPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlTypeRegistrarPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlWorkerScript) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlWorkerScript REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlWorkerScript) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlWorkerScript CONFIG) ..."
            rm -rf "$TmpDir/build_58"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_58" 0 \
                "cmake configuration (find_package Qt6QmlWorkerScript CONFIG)"; then
                rlPass "find_package(Qt6QmlWorkerScript CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlWorkerScript CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlWorkerScriptPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlWorkerScriptPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlWorkerScriptPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlWorkerScriptPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_59"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_59" 0 \
                "cmake configuration (find_package Qt6QmlWorkerScriptPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlWorkerScriptPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlWorkerScriptPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlXmlListModel) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QmlXmlListModel REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlXmlListModel) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlXmlListModel CONFIG) ..."
            rm -rf "$TmpDir/build_60"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_60" 0 \
                "cmake configuration (find_package Qt6QmlXmlListModel CONFIG)"; then
                rlPass "find_package(Qt6QmlXmlListModel CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlXmlListModel CONFIG) verification failed"
            fi

            # --- find_package(Qt6QmlXmlListModelPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QmlXmlListModelPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QmlXmlListModelPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QmlXmlListModelPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_61"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_61" 0 \
                "cmake configuration (find_package Qt6QmlXmlListModelPrivate CONFIG)"; then
                rlPass "find_package(Qt6QmlXmlListModelPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QmlXmlListModelPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6Quick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Quick REQUIRED CONFIG)

message(STATUS "find_package(Qt6Quick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Quick CONFIG) ..."
            rm -rf "$TmpDir/build_62"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_62" 0 \
                "cmake configuration (find_package Qt6Quick CONFIG)"; then
                rlPass "find_package(Qt6Quick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2 REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2 CONFIG) ..."
            rm -rf "$TmpDir/build_63"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_63" 0 \
                "cmake configuration (find_package Qt6QuickControls2 CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2 CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2 CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Basic) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2Basic REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Basic) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Basic CONFIG) ..."
            rm -rf "$TmpDir/build_64"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_64" 0 \
                "cmake configuration (find_package Qt6QuickControls2Basic CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Basic CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Basic CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2BasicPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2BasicPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2BasicPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2BasicPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_65"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_65" 0 \
                "cmake configuration (find_package Qt6QuickControls2BasicPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2BasicPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2BasicPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2BasicStyleImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2BasicStyleImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2BasicStyleImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2BasicStyleImpl CONFIG) ..."
            rm -rf "$TmpDir/build_66"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_66" 0 \
                "cmake configuration (find_package Qt6QuickControls2BasicStyleImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2BasicStyleImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2BasicStyleImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2BasicStyleImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2BasicStyleImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2BasicStyleImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2BasicStyleImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_67"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_67" 0 \
                "cmake configuration (find_package Qt6QuickControls2BasicStyleImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2BasicStyleImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2BasicStyleImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2FluentWinUI3StyleImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2FluentWinUI3StyleImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2FluentWinUI3StyleImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2FluentWinUI3StyleImpl CONFIG) ..."
            rm -rf "$TmpDir/build_68"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_68" 0 \
                "cmake configuration (find_package Qt6QuickControls2FluentWinUI3StyleImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2FluentWinUI3StyleImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2FluentWinUI3StyleImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2FluentWinUI3StyleImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2FluentWinUI3StyleImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2FluentWinUI3StyleImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2FluentWinUI3StyleImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_69"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_69" 0 \
                "cmake configuration (find_package Qt6QuickControls2FluentWinUI3StyleImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2FluentWinUI3StyleImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2FluentWinUI3StyleImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Fusion) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2Fusion REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Fusion) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Fusion CONFIG) ..."
            rm -rf "$TmpDir/build_70"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_70" 0 \
                "cmake configuration (find_package Qt6QuickControls2Fusion CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Fusion CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Fusion CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2FusionPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2FusionPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2FusionPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2FusionPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_71"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_71" 0 \
                "cmake configuration (find_package Qt6QuickControls2FusionPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2FusionPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2FusionPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2FusionStyleImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2FusionStyleImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2FusionStyleImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2FusionStyleImpl CONFIG) ..."
            rm -rf "$TmpDir/build_72"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_72" 0 \
                "cmake configuration (find_package Qt6QuickControls2FusionStyleImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2FusionStyleImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2FusionStyleImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2FusionStyleImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2FusionStyleImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2FusionStyleImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2FusionStyleImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_73"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_73" 0 \
                "cmake configuration (find_package Qt6QuickControls2FusionStyleImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2FusionStyleImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2FusionStyleImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Imagine) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2Imagine REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Imagine) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Imagine CONFIG) ..."
            rm -rf "$TmpDir/build_74"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_74" 0 \
                "cmake configuration (find_package Qt6QuickControls2Imagine CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Imagine CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Imagine CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2ImaginePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2ImaginePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2ImaginePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2ImaginePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_75"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_75" 0 \
                "cmake configuration (find_package Qt6QuickControls2ImaginePrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2ImaginePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2ImaginePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2ImagineStyleImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2ImagineStyleImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2ImagineStyleImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2ImagineStyleImpl CONFIG) ..."
            rm -rf "$TmpDir/build_76"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_76" 0 \
                "cmake configuration (find_package Qt6QuickControls2ImagineStyleImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2ImagineStyleImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2ImagineStyleImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Impl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2Impl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Impl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Impl CONFIG) ..."
            rm -rf "$TmpDir/build_77"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_77" 0 \
                "cmake configuration (find_package Qt6QuickControls2Impl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Impl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Impl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2ImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2ImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2ImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2ImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_78"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_78" 0 \
                "cmake configuration (find_package Qt6QuickControls2ImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2ImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2ImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Material) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2Material REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Material) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Material CONFIG) ..."
            rm -rf "$TmpDir/build_79"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_79" 0 \
                "cmake configuration (find_package Qt6QuickControls2Material CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Material CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Material CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2MaterialPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2MaterialPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2MaterialPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2MaterialPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_80"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_80" 0 \
                "cmake configuration (find_package Qt6QuickControls2MaterialPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2MaterialPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2MaterialPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2MaterialStyleImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2MaterialStyleImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2MaterialStyleImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2MaterialStyleImpl CONFIG) ..."
            rm -rf "$TmpDir/build_81"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_81" 0 \
                "cmake configuration (find_package Qt6QuickControls2MaterialStyleImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2MaterialStyleImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2MaterialStyleImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2MaterialStyleImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2MaterialStyleImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2MaterialStyleImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2MaterialStyleImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_82"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_82" 0 \
                "cmake configuration (find_package Qt6QuickControls2MaterialStyleImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2MaterialStyleImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2MaterialStyleImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Private) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2Private REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Private) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Private CONFIG) ..."
            rm -rf "$TmpDir/build_83"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_83" 0 \
                "cmake configuration (find_package Qt6QuickControls2Private CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Private CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Private CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2Universal) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2Universal REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2Universal) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2Universal CONFIG) ..."
            rm -rf "$TmpDir/build_84"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_84" 0 \
                "cmake configuration (find_package Qt6QuickControls2Universal CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2Universal CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2Universal CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2UniversalPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2UniversalPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2UniversalPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2UniversalPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_85"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_85" 0 \
                "cmake configuration (find_package Qt6QuickControls2UniversalPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2UniversalPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2UniversalPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2UniversalStyleImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickControls2UniversalStyleImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2UniversalStyleImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2UniversalStyleImpl CONFIG) ..."
            rm -rf "$TmpDir/build_86"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_86" 0 \
                "cmake configuration (find_package Qt6QuickControls2UniversalStyleImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2UniversalStyleImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2UniversalStyleImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControls2UniversalStyleImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControls2UniversalStyleImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControls2UniversalStyleImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControls2UniversalStyleImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_87"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_87" 0 \
                "cmake configuration (find_package Qt6QuickControls2UniversalStyleImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControls2UniversalStyleImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControls2UniversalStyleImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickControlsTestUtilsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickControlsTestUtilsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickControlsTestUtilsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickControlsTestUtilsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_88"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_88" 0 \
                "cmake configuration (find_package Qt6QuickControlsTestUtilsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickControlsTestUtilsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickControlsTestUtilsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickDialogs2) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickDialogs2 REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickDialogs2) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickDialogs2 CONFIG) ..."
            rm -rf "$TmpDir/build_90"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_90" 0 \
                "cmake configuration (find_package Qt6QuickDialogs2 CONFIG)"; then
                rlPass "find_package(Qt6QuickDialogs2 CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickDialogs2 CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickDialogs2Private) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickDialogs2Private REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickDialogs2Private) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickDialogs2Private CONFIG) ..."
            rm -rf "$TmpDir/build_91"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_91" 0 \
                "cmake configuration (find_package Qt6QuickDialogs2Private CONFIG)"; then
                rlPass "find_package(Qt6QuickDialogs2Private CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickDialogs2Private CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickDialogs2QuickImpl) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickDialogs2QuickImpl REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickDialogs2QuickImpl) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickDialogs2QuickImpl CONFIG) ..."
            rm -rf "$TmpDir/build_92"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_92" 0 \
                "cmake configuration (find_package Qt6QuickDialogs2QuickImpl CONFIG)"; then
                rlPass "find_package(Qt6QuickDialogs2QuickImpl CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickDialogs2QuickImpl CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickDialogs2QuickImplPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickDialogs2QuickImplPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickDialogs2QuickImplPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickDialogs2QuickImplPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_93"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_93" 0 \
                "cmake configuration (find_package Qt6QuickDialogs2QuickImplPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickDialogs2QuickImplPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickDialogs2QuickImplPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickDialogs2Utils) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickDialogs2Utils REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickDialogs2Utils) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickDialogs2Utils CONFIG) ..."
            rm -rf "$TmpDir/build_94"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_94" 0 \
                "cmake configuration (find_package Qt6QuickDialogs2Utils CONFIG)"; then
                rlPass "find_package(Qt6QuickDialogs2Utils CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickDialogs2Utils CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickDialogs2UtilsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickDialogs2UtilsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickDialogs2UtilsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickDialogs2UtilsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_95"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_95" 0 \
                "cmake configuration (find_package Qt6QuickDialogs2UtilsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickDialogs2UtilsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickDialogs2UtilsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickEffects) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickEffects REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickEffects) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickEffects CONFIG) ..."
            rm -rf "$TmpDir/build_96"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_96" 0 \
                "cmake configuration (find_package Qt6QuickEffects CONFIG)"; then
                rlPass "find_package(Qt6QuickEffects CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickEffects CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickEffectsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickEffectsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickEffectsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickEffectsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_97"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_97" 0 \
                "cmake configuration (find_package Qt6QuickEffectsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickEffectsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickEffectsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickLayouts) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickLayouts REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickLayouts) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickLayouts CONFIG) ..."
            rm -rf "$TmpDir/build_98"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_98" 0 \
                "cmake configuration (find_package Qt6QuickLayouts CONFIG)"; then
                rlPass "find_package(Qt6QuickLayouts CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickLayouts CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickLayoutsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickLayoutsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickLayoutsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickLayoutsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_99"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_99" 0 \
                "cmake configuration (find_package Qt6QuickLayoutsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickLayoutsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickLayoutsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickParticlesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickParticlesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickParticlesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickParticlesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_100"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_100" 0 \
                "cmake configuration (find_package Qt6QuickParticlesPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickParticlesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickParticlesPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_101"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_101" 0 \
                "cmake configuration (find_package Qt6QuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickShapes) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickShapes REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickShapes) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickShapes CONFIG) ..."
            rm -rf "$TmpDir/build_102"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_102" 0 \
                "cmake configuration (find_package Qt6QuickShapes CONFIG)"; then
                rlPass "find_package(Qt6QuickShapes CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickShapes CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickShapesDesignHelpersPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickShapesDesignHelpersPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickShapesDesignHelpersPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickShapesDesignHelpersPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_103"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_103" 0 \
                "cmake configuration (find_package Qt6QuickShapesDesignHelpersPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickShapesDesignHelpersPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickShapesDesignHelpersPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickShapesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickShapesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickShapesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickShapesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_104"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_104" 0 \
                "cmake configuration (find_package Qt6QuickShapesPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickShapesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickShapesPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickTemplates2) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickTemplates2 REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickTemplates2) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickTemplates2 CONFIG) ..."
            rm -rf "$TmpDir/build_105"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_105" 0 \
                "cmake configuration (find_package Qt6QuickTemplates2 CONFIG)"; then
                rlPass "find_package(Qt6QuickTemplates2 CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickTemplates2 CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickTemplates2Private) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickTemplates2Private REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickTemplates2Private) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickTemplates2Private CONFIG) ..."
            rm -rf "$TmpDir/build_106"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_106" 0 \
                "cmake configuration (find_package Qt6QuickTemplates2Private CONFIG)"; then
                rlPass "find_package(Qt6QuickTemplates2Private CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickTemplates2Private CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickTest) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickTest REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickTest) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickTest CONFIG) ..."
            rm -rf "$TmpDir/build_107"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_107" 0 \
                "cmake configuration (find_package Qt6QuickTest CONFIG)"; then
                rlPass "find_package(Qt6QuickTest CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickTest CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickTestPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickTestPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickTestPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickTestPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_108"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_108" 0 \
                "cmake configuration (find_package Qt6QuickTestPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickTestPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickTestPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickTestUtilsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickTestUtilsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickTestUtilsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickTestUtilsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_109"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_109" 0 \
                "cmake configuration (find_package Qt6QuickTestUtilsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickTestUtilsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickTestUtilsPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickTools CONFIG) ..."
            rm -rf "$TmpDir/build_111"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_111" 0 \
                "cmake configuration (find_package Qt6QuickTools CONFIG)"; then
                rlPass "find_package(Qt6QuickTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickVectorImage) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickVectorImage REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickVectorImage) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickVectorImage CONFIG) ..."
            rm -rf "$TmpDir/build_112"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_112" 0 \
                "cmake configuration (find_package Qt6QuickVectorImage CONFIG)"; then
                rlPass "find_package(Qt6QuickVectorImage CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickVectorImage CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickVectorImageGeneratorPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickVectorImageGeneratorPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickVectorImageGeneratorPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickVectorImageGeneratorPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_113"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_113" 0 \
                "cmake configuration (find_package Qt6QuickVectorImageGeneratorPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickVectorImageGeneratorPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickVectorImageGeneratorPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickVectorImageHelpers) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickVectorImageHelpers REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickVectorImageHelpers) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickVectorImageHelpers CONFIG) ..."
            rm -rf "$TmpDir/build_114"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_114" 0 \
                "cmake configuration (find_package Qt6QuickVectorImageHelpers CONFIG)"; then
                rlPass "find_package(Qt6QuickVectorImageHelpers CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickVectorImageHelpers CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickVectorImageHelpersPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickVectorImageHelpersPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickVectorImageHelpersPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickVectorImageHelpersPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_115"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_115" 0 \
                "cmake configuration (find_package Qt6QuickVectorImageHelpersPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickVectorImageHelpersPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickVectorImageHelpersPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickVectorImagePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickVectorImagePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickVectorImagePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickVectorImagePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_116"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_116" 0 \
                "cmake configuration (find_package Qt6QuickVectorImagePrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickVectorImagePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickVectorImagePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickWidgets) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6QuickWidgets REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickWidgets) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickWidgets CONFIG) ..."
            rm -rf "$TmpDir/build_117"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_117" 0 \
                "cmake configuration (find_package Qt6QuickWidgets CONFIG)"; then
                rlPass "find_package(Qt6QuickWidgets CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickWidgets CONFIG) verification failed"
            fi

            # --- find_package(Qt6QuickWidgetsPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6QuickWidgetsPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6QuickWidgetsPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6QuickWidgetsPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_118"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_118" 0 \
                "cmake configuration (find_package Qt6QuickWidgetsPrivate CONFIG)"; then
                rlPass "find_package(Qt6QuickWidgetsPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6QuickWidgetsPrivate CONFIG) verification failed"
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

#!/bin/bash
# Functional test: qt6-qtlottie-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtlottie-devel"

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

            # --- find_package(Qt6Lottie) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Lottie REQUIRED CONFIG)

message(STATUS "find_package(Qt6Lottie) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Lottie CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6Lottie CONFIG)"; then
                rlPass "find_package(Qt6Lottie CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Lottie CONFIG) verification failed"
            fi

            # --- find_package(Qt6LottiePrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LottiePrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LottiePrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LottiePrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6LottiePrivate CONFIG)"; then
                rlPass "find_package(Qt6LottiePrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LottiePrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LottieTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LottieTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6LottieTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LottieTools CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6LottieTools CONFIG)"; then
                rlPass "find_package(Qt6LottieTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LottieTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6LottieVectorImageGeneratorPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LottieVectorImageGeneratorPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LottieVectorImageGeneratorPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LottieVectorImageGeneratorPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6LottieVectorImageGeneratorPrivate CONFIG)"; then
                rlPass "find_package(Qt6LottieVectorImageGeneratorPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LottieVectorImageGeneratorPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6LottieVectorImageHelpers) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6LottieVectorImageHelpers REQUIRED CONFIG)

message(STATUS "find_package(Qt6LottieVectorImageHelpers) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LottieVectorImageHelpers CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6LottieVectorImageHelpers CONFIG)"; then
                rlPass "find_package(Qt6LottieVectorImageHelpers CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LottieVectorImageHelpers CONFIG) verification failed"
            fi

            # --- find_package(Qt6LottieVectorImageHelpersPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6LottieVectorImageHelpersPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6LottieVectorImageHelpersPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6LottieVectorImageHelpersPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6LottieVectorImageHelpersPrivate CONFIG)"; then
                rlPass "find_package(Qt6LottieVectorImageHelpersPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6LottieVectorImageHelpersPrivate CONFIG) verification failed"
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
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6Quick CONFIG)"; then
                rlPass "find_package(Qt6Quick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Quick CONFIG) verification failed"
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

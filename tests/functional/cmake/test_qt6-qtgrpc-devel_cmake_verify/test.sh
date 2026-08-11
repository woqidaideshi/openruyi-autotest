#!/bin/bash
# Functional test: qt6-qtgrpc-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="qt6-qtgrpc-devel"

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

            # --- find_package(Qt6Grpc) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Grpc REQUIRED CONFIG)

message(STATUS "find_package(Qt6Grpc) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Grpc CONFIG) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package Qt6Grpc CONFIG)"; then
                rlPass "find_package(Qt6Grpc CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Grpc CONFIG) verification failed"
            fi

            # --- find_package(Qt6GrpcPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6GrpcPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6GrpcPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6GrpcPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package Qt6GrpcPrivate CONFIG)"; then
                rlPass "find_package(Qt6GrpcPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6GrpcPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6GrpcQuick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6GrpcQuick REQUIRED CONFIG)

message(STATUS "find_package(Qt6GrpcQuick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6GrpcQuick CONFIG) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package Qt6GrpcQuick CONFIG)"; then
                rlPass "find_package(Qt6GrpcQuick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6GrpcQuick CONFIG) verification failed"
            fi

            # --- find_package(Qt6GrpcQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6GrpcQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6GrpcQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6GrpcQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_4"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_4" 0 \
                "cmake configuration (find_package Qt6GrpcQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6GrpcQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6GrpcQuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6GrpcTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6GrpcTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6GrpcTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6GrpcTools CONFIG) ..."
            rm -rf "$TmpDir/build_5"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_5" 0 \
                "cmake configuration (find_package Qt6GrpcTools CONFIG)"; then
                rlPass "find_package(Qt6GrpcTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6GrpcTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6Protobuf) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6Protobuf REQUIRED CONFIG)

message(STATUS "find_package(Qt6Protobuf) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6Protobuf CONFIG) ..."
            rm -rf "$TmpDir/build_6"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_6" 0 \
                "cmake configuration (find_package Qt6Protobuf CONFIG)"; then
                rlPass "find_package(Qt6Protobuf CONFIG) verification passed"
            else
                rlFail "find_package(Qt6Protobuf CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_7"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_7" 0 \
                "cmake configuration (find_package Qt6ProtobufPrivate CONFIG)"; then
                rlPass "find_package(Qt6ProtobufPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufQtCoreTypes) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6ProtobufQtCoreTypes REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufQtCoreTypes) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufQtCoreTypes CONFIG) ..."
            rm -rf "$TmpDir/build_8"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_8" 0 \
                "cmake configuration (find_package Qt6ProtobufQtCoreTypes CONFIG)"; then
                rlPass "find_package(Qt6ProtobufQtCoreTypes CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufQtCoreTypes CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufQtCoreTypesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufQtCoreTypesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufQtCoreTypesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufQtCoreTypesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_9"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_9" 0 \
                "cmake configuration (find_package Qt6ProtobufQtCoreTypesPrivate CONFIG)"; then
                rlPass "find_package(Qt6ProtobufQtCoreTypesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufQtCoreTypesPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufQtGuiTypes) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6ProtobufQtGuiTypes REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufQtGuiTypes) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufQtGuiTypes CONFIG) ..."
            rm -rf "$TmpDir/build_10"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_10" 0 \
                "cmake configuration (find_package Qt6ProtobufQtGuiTypes CONFIG)"; then
                rlPass "find_package(Qt6ProtobufQtGuiTypes CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufQtGuiTypes CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufQtGuiTypesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufQtGuiTypesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufQtGuiTypesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufQtGuiTypesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_11"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_11" 0 \
                "cmake configuration (find_package Qt6ProtobufQtGuiTypesPrivate CONFIG)"; then
                rlPass "find_package(Qt6ProtobufQtGuiTypesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufQtGuiTypesPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufQuick) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6ProtobufQuick REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufQuick) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufQuick CONFIG) ..."
            rm -rf "$TmpDir/build_12"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_12" 0 \
                "cmake configuration (find_package Qt6ProtobufQuick CONFIG)"; then
                rlPass "find_package(Qt6ProtobufQuick CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufQuick CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufQuickPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufQuickPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufQuickPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufQuickPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_13"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_13" 0 \
                "cmake configuration (find_package Qt6ProtobufQuickPrivate CONFIG)"; then
                rlPass "find_package(Qt6ProtobufQuickPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufQuickPrivate CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufTools) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufTools REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufTools) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufTools CONFIG) ..."
            rm -rf "$TmpDir/build_14"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_14" 0 \
                "cmake configuration (find_package Qt6ProtobufTools CONFIG)"; then
                rlPass "find_package(Qt6ProtobufTools CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufTools CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufWellKnownTypes) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufWellKnownTypes REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufWellKnownTypes) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufWellKnownTypes CONFIG) ..."
            rm -rf "$TmpDir/build_15"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_15" 0 \
                "cmake configuration (find_package Qt6ProtobufWellKnownTypes CONFIG)"; then
                rlPass "find_package(Qt6ProtobufWellKnownTypes CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufWellKnownTypes CONFIG) verification failed"
            fi

            # --- find_package(Qt6ProtobufWellKnownTypesPrivate) ---
            cat > "$TmpDir/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

find_package(Qt6 REQUIRED CONFIG)
find_package(Qt6ProtobufWellKnownTypesPrivate REQUIRED CONFIG)

message(STATUS "find_package(Qt6ProtobufWellKnownTypesPrivate) succeeded")
EOF

            rlLogInfo "Verifying find_package(Qt6ProtobufWellKnownTypesPrivate CONFIG) ..."
            rm -rf "$TmpDir/build_16"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_16" 0 \
                "cmake configuration (find_package Qt6ProtobufWellKnownTypesPrivate CONFIG)"; then
                rlPass "find_package(Qt6ProtobufWellKnownTypesPrivate CONFIG) verification passed"
            else
                rlFail "find_package(Qt6ProtobufWellKnownTypesPrivate CONFIG) verification failed"
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

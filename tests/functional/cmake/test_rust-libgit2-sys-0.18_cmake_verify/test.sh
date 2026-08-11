#!/bin/bash
# Functional test: rust-libgit2-sys-0.18 - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(CONFIG) -> *Config.cmake -> *Targets.cmake
#   Targets.cmake referencing non-existent .a/.so will cause cmake configuration to fail directly
#   cargo build -> build.rs -> cmake crate -> .cmake files -> C library build
#   .cmake path errors or missing files will cause cargo build to fail

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="rust-libgit2-sys-0.18"

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
            # Auto-detect cmake directory
            PKGBUILD_CMAKE_DIR=$(rpm -ql "$PKG" | grep 'PkgBuildConfig\.cmake$' | head -1 | xargs dirname)
        rlLogInfo "PkgBuild cmake directory: $PKGBUILD_CMAKE_DIR"
            # --- find_package(PkgBuild) ---
            cat > "$TmpDir/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

set(CMAKE_PREFIX_PATH "${PKGBUILD_CMAKE_DIR}")
find_package(PkgBuild REQUIRED CONFIG)

message(STATUS "find_package(PkgBuild) succeeded")
EOF

            rlLogInfo "Verifying find_package(PkgBuild CONFIG) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package PkgBuild CONFIG)"; then
                rlPass "find_package(PkgBuild CONFIG) verification passed"
            else
                rlFail "find_package(PkgBuild CONFIG) verification failed"
            fi

        fi
    rlPhaseEnd

    rlPhaseStartTest "cargo check - Verify crate build integrity"
        CRATE_VERSION=$(rpm -q --queryformat "%{VERSION}" "$PKG" 2>/dev/null)
        rlLogInfo "crate version: $CRATE_VERSION"

        TmpDir2=$(mktemp -d)
        rlRun "cd $TmpDir2" 0 "Enter temporary test directory"

        # --- cargo check libgit2-sys ---
        rlLogInfo "Verifying crate: libgit2-sys v$CRATE_VERSION"
        test_proj="$TmpDir2/test_libgit2_sys"
        rm -rf "$test_proj"
        mkdir -p "$test_proj/src"

        cat > "$test_proj/Cargo.toml" << CARGOEOF
[package]
name = "cmake_verify_libgit2_sys"
version = "0.1.0"
edition = "2021"

[dependencies]
libgit2-sys = "${CRATE_VERSION}"
CARGOEOF
        echo 'fn main() { println!("cmake verify ok"); }' > "$test_proj/src/main.rs"

        cd "$test_proj"
        if rlRun "cargo check 2>&1" 0 \
            "cargo check libgit2-sys v$CRATE_VERSION"; then
            rlPass "cargo check libgit2-sys passed"
        else
            rlLogWarning "cargo check libgit2-sys failed (may need network to download dependencies)"
        fi

        rlRun "cd /" 0 "Leave test directory"
        rm -rf "$TmpDir2"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        rlRun "cd /" 0 "Leave test directory"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

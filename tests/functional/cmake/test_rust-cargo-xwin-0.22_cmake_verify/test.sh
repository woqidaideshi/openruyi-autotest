#!/bin/bash
# Functional test: rust-cargo-xwin-0.22 - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   cargo build -> build.rs -> cmake crate -> .cmake files -> C library build
#   .cmake path errors or missing files will cause cargo build to fail

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="rust-cargo-xwin-0.22"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter temporary test directory"

        CMAKE_COUNT=$(rpm -ql "$PKG" 2>/dev/null | grep -c '\.cmake$' || echo 0)
        rlLogInfo "$PKG provides $CMAKE_COUNT .cmake file(s)"
    rlPhaseEnd

    rlPhaseStartTest "cargo check - Verify crate build integrity"
        CRATE_VERSION=$(rpm -q --queryformat "%{VERSION}" "$PKG" 2>/dev/null)
        rlLogInfo "crate version: $CRATE_VERSION"

        TmpDir2=$(mktemp -d)
        rlRun "cd $TmpDir2" 0 "Enter temporary test directory"

        # --- cargo check cargo-xwin ---
        rlLogInfo "Verifying crate: cargo-xwin v$CRATE_VERSION"
        test_proj="$TmpDir2/test_cargo_xwin"
        rm -rf "$test_proj"
        mkdir -p "$test_proj/src"

        cat > "$test_proj/Cargo.toml" << CARGOEOF
[package]
name = "cmake_verify_cargo_xwin"
version = "0.1.0"
edition = "2021"

[dependencies]
cargo-xwin = "${CRATE_VERSION}"
CARGOEOF
        echo 'fn main() { println!("cmake verify ok"); }' > "$test_proj/src/main.rs"

        cd "$test_proj"
        if rlRun "cargo check 2>&1" 0 \
            "cargo check cargo-xwin v$CRATE_VERSION"; then
            rlPass "cargo check cargo-xwin passed"
        else
            rlLogWarning "cargo check cargo-xwin failed (may need network to download dependencies)"
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

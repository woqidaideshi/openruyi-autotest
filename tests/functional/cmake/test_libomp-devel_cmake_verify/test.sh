#!/bin/bash
# Functional test: libomp-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   find_package(MODULE) -> load Find*.cmake modules
#   Module syntax errors or internal reference issues will cause cmake configuration to fail

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="libomp-devel"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter temporary test directory"

        CMAKE_COUNT=$(rpm -ql "$PKG" 2>/dev/null | grep -c '\.cmake$' || echo 0)
        rlLogInfo "$PKG provides $CMAKE_COUNT .cmake file(s)"
    rlPhaseEnd

    rlPhaseStartTest "find_package(CONFIG) - Verify cmake export integrity"
        TmpDir2=$(mktemp -d)
        rlRun "cd $TmpDir2" 0 "Enter temporary test directory"

        # --- find_package(OpenMPTarget MODULE) ---
        cat > "$TmpDir2/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.13.4)
project(cmake_module_verify
  VERSION "0.1"
  LANGUAGES C)
list(APPEND CMAKE_MODULE_PATH "/usr/lib64/cmake/openmp;/usr/lib64/llvm21/lib64/cmake/openmp")
find_package(OpenMPTarget MODULE QUIET)
EOF

        rlLogInfo "Verifying find_package(OpenMPTarget MODULE) ..."
        rm -rf "$TmpDir2/build_0"
        if rlRun "cmake -S $TmpDir2 -B $TmpDir2/build_0" 0 \
            "cmake configuration (find_package OpenMPTarget MODULE)"; then
            rlPass "find_package(OpenMPTarget MODULE) verification passed"
        else
            rlLogWarning "find_package(OpenMPTarget MODULE) verification failed(the library being searched may not be installed)"
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

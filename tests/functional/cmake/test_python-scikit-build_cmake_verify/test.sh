#!/bin/bash
# Functional test: python-scikit-build - cmake module verification
# Verify that Find*.cmake modules provided by the package can be loaded
# without syntax errors or internal bugs
#
# Verification principle:
#   find_package(MODULE) -> load Find*.cmake modules
#   Module syntax errors or internal reference issues will cause cmake configuration to fail

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="python-scikit-build"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter temporary test directory"

        CMAKE_COUNT=$(rpm -ql "$PKG" 2>/dev/null | grep -c '\.cmake$' || echo 0)
        rlLogInfo "$PKG provides $CMAKE_COUNT .cmake file(s)"
    rlPhaseEnd

    rlPhaseStartTest "find_package(MODULE) - Verify cmake module integrity"
        if [ "$CMAKE_COUNT" -eq 0 ]; then
            rlLogWarning "$PKG provides no .cmake files, skipping cmake verification"
        else
            MODULE_PATH="/usr/lib/python3.13/site-packages/skbuild/resources/cmake"

            # --- find_package(Cython MODULE) ---
            cat > "$TmpDir/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.13.4)
list(APPEND CMAKE_MODULE_PATH "${MODULE_PATH}")
find_package(Cython MODULE QUIET)
EOF

            rlLogInfo "Verifying find_package(Cython MODULE) ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (find_package Cython MODULE)"; then
                rlPass "find_package(Cython MODULE) verification passed"
            else
                rlLogWarning "find_package(Cython MODULE) verification failed"
            fi

            # --- find_package(F2PY MODULE) ---
            cat > "$TmpDir/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.13.4)
find_package(PythonInterp REQUIRED)
list(APPEND CMAKE_MODULE_PATH "${MODULE_PATH}")
find_package(F2PY MODULE QUIET)
EOF

            rlLogInfo "Verifying find_package(F2PY MODULE) ..."
            rm -rf "$TmpDir/build_1"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_1" 0 \
                "cmake configuration (find_package F2PY MODULE)"; then
                rlPass "find_package(F2PY MODULE) verification passed"
            else
                rlLogWarning "find_package(F2PY MODULE) verification failed"
            fi

            # --- find_package(NumPy MODULE) ---
            cat > "$TmpDir/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.13.4)
list(APPEND CMAKE_MODULE_PATH "${MODULE_PATH}")
find_package(NumPy MODULE QUIET)
EOF

            rlLogInfo "Verifying find_package(NumPy MODULE) ..."
            rm -rf "$TmpDir/build_2"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_2" 0 \
                "cmake configuration (find_package NumPy MODULE)"; then
                rlPass "find_package(NumPy MODULE) verification passed"
            else
                rlLogWarning "find_package(NumPy MODULE) verification failed"
            fi

            # --- find_package(PythonExtensions MODULE) ---
            cat > "$TmpDir/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.13.4)
list(APPEND CMAKE_MODULE_PATH "${MODULE_PATH}")
find_package(PythonExtensions MODULE QUIET)
EOF

            rlLogInfo "Verifying find_package(PythonExtensions MODULE) ..."
            rm -rf "$TmpDir/build_3"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_3" 0 \
                "cmake configuration (find_package PythonExtensions MODULE)"; then
                rlPass "find_package(PythonExtensions MODULE) verification passed"
            else
                rlLogWarning "find_package(PythonExtensions MODULE) verification failed"
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

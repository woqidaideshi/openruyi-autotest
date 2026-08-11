#!/bin/bash
# Functional test: graphite2-devel - cmake export integrity verification
# Verify that all files referenced by .cmake files provided by the package actually exist
#
# Verification principle:
#   include(*.cmake) -> add_library(... IMPORTED) -> target_link_libraries
#   Linking against imported targets triggers IMPORTED_LOCATION file existence check

. /usr/share/beakerlib/beakerlib.sh || exit 1

PKG="graphite2-devel"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter temporary test directory"

        CMAKE_COUNT=$(rpm -ql "$PKG" 2>/dev/null | grep -c '\.cmake$' || echo 0)
        rlLogInfo "$PKG provides $CMAKE_COUNT .cmake file(s)"

        # Find the cmake file containing IMPORTED targets and extract target name
        TARGETS_FILE=$(rpm -ql "$PKG" 2>/dev/null | grep '\.cmake$' | \
            xargs grep -l 'add_library.*IMPORTED' 2>/dev/null | head -1)
        TARGET_NAME=$(grep -hoP 'add_library\(\K[^ ]+(?=\s+(?:SHARED|STATIC|UNKNOWN)\s+IMPORTED)' "$TARGETS_FILE" 2>/dev/null | head -1)
        rlLogInfo "Targets file: ${TARGETS_FILE:-N/A}"
        rlLogInfo "Imported target: ${TARGET_NAME:-N/A}"
    rlPhaseEnd

    rlPhaseStartTest "include + link - Verify cmake export integrity"
        if [ -z "$TARGETS_FILE" ] || [ -z "$TARGET_NAME" ]; then
            rlLogInfo "No IMPORTED target found, skipping link verification"
        else
            cat > "$TmpDir/test_main.cpp" << 'EOF'
#include <graphite2/Font.h>
int main() { return 0; }
EOF

            cat > "$TmpDir/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.13.4)
project(cmake_verify
  VERSION "0.1"
  LANGUAGES C CXX)

include("${TARGETS_FILE}")

add_executable(test_main test_main.cpp)

# Link against the imported target to verify .so/.a existence
# This catches #760 class of bugs where .cmake references non-existent files
target_link_libraries(test_main PRIVATE ${TARGET_NAME})
EOF

            rlLogInfo "Verifying include + link ..."
            rm -rf "$TmpDir/build_0"
            if rlRun "cmake -S $TmpDir -B $TmpDir/build_0" 0 \
                "cmake configuration (include + link)"; then
                rlPass "include + link verification passed"
            else
                rlFail "include + link verification failed"
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

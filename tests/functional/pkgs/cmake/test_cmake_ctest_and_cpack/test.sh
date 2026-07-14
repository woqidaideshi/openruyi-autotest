#!/bin/bash
# Functional test: cmake - ctest-and-cpack
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    cmakeSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "ctest-and-cpack"
    rlRun "ctest --version" 0 "check ctest version info"
    rlRun "cpack --version" 0 "check cpack version info"
    rlRun "ctest --help 2>&1 | grep -q Usage" 0 "ctest --help Show usage"
    rlRun "cpack --help 2>&1 | grep -q Usage" 0 "cpack --help Show usage"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # cmake Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

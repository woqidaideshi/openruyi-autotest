#!/bin/bash
# Functional test: clang - Debug-and-warnings
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    clangSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "Debug-and-warnings"
    rlRun "clang -g -c hello.c -o hello_g.o" 0 "Debug symbols"
    rlRun "clang -Wall -c hello.c -o hello_Wall.o" 0 "-Wall warnings"
    rlRun "clang -Wextra -c hello.c -o hello_Wextra.o" 0 "-Wextra warnings"
    rlRun "clang -Werror -c hello.c -o hello_Werror.o" 0 "-Werror"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # clang Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

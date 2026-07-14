#!/bin/bash
# Functional test: coreutils - Special-utilities--stty--pathchk--tsort--ptx--dirc
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    coreutilsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "Special-utilities--stty--pathchk--tsort--ptx--dirc"
    rlRun "stty -a" 0 "stty -a show all terminal settings"
    rlRun "pathchk /tmp" 0 "pathchk validate path"
    rlRun "pathchk -p /tmp" 0 "pathchk -p POSIX check"
    rlRun "echo -e \"a b\nb c\" | tsort" 0 "tsort topological sort"
    rlRun "ptx fruits.txt" 0 "ptx permuted index"
    rlRun "dircolors -p" 0 "dircolors -p print database"
    rlRun "dircolors" 0 "dircolors output LS_COLORS"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # coreutils Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

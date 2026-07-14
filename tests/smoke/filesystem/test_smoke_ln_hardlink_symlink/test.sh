#!/bin/bash
# Smoke test: filesystem - ln hardlink and symlink
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeFSSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlRun "echo 'link test' > target.txt" 0 "createtargetfile"
    rlPhaseEnd

    rlPhaseStartTest "ln createhardlinkandsymbollink"
    rlRun "ln target.txt hardlink.txt" 0 "ln createhardlink"
    rlRun "ln -s target.txt symlink.txt" 0 "ln -s createsymbollink"
    rlRun "test -f hardlink.txt" 0 "hardlinkexists"
    rlRun "test -L symlink.txt" 0 "symbollinkexists"
    rlRun "cat hardlink.txt" 0 "hardlinkreadable"
    rlRun "cat symlink.txt" 0 "symbollinkreadable"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
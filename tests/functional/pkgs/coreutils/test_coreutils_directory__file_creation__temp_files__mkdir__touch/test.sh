#!/bin/bash
# Functional test: coreutils - Directory--file-creation--temp-files--mkdir--touch
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

    rlPhaseStartTest "Directory--file-creation--temp-files--mkdir--touch"
    rlRun "mkdir -p a/b/c" 0 "mkdir -p nested directories"
    rlRun "test -d a/b/c" 0 "mkdir -p: verify nested dir"
    rlRun "mkdir -m 755 mode_dir" 0 "mkdir -m set mode"
    rlRun "touch newfile.txt" 0 "touch create file"
    rlRun "test -f newfile.txt" 0 "touch: file exists"
    rlRun "touch -t 202001010000 newfile.txt" 0 "touch -t set timestamp"
    rlRun "touch -a newfile.txt" 0 "touch -a access time only"
    rlRun "mktemp" 0 "mktemp create temp file"
    rlRun "test -f $mktemp_f" 0 "mktemp: temp file exists"
    rlRun "mktemp -d" 0 "mktemp -d create temp directory"
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

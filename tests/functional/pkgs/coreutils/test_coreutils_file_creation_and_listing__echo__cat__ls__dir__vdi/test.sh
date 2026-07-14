#!/bin/bash
# Functional test: coreutils - File-creation-and-listing--echo--cat--ls--dir--vdi
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

    rlPhaseStartTest "File-creation-and-listing--echo--cat--ls--dir--vdi"
    rlRun "echo \"line1\" > file1.txt" 0 "echo create file"
    rlRun "echo \"line2\" >> file1.txt" 0 "echo append"
    rlRun "echo -n \"no_newline\" > no_nl.txt" 0 "echo -n suppress newline"
    rlRun "test $(wc -c < no_nl.txt) -eq 10" 0 "echo -n: verify no trailing newline"
    rlRun "cat file1.txt" 0 "cat display file"
    rlRun "test $(cat file1.txt | wc -l) -eq 2" 0 "cat: verify 2 lines"
    rlRun "cat -n file1.txt" 0 "cat -n number all lines"
    rlRun "cat -b file1.txt" 0 "cat -b number non-blank lines"
    rlRun "ls -la" 0 "ls -la list all files"
    rlRun "ls file1.txt" 0 "ls specific file"
    rlRun "ls -l file1.txt | grep -q \"^-\"" 0 "ls -l: regular file check"
    rlRun "ls -ld ls_testdir | grep -q \"^d\"" 0 "ls -ld: directory check"
    rlRun "ls -1" 0 "ls -1 single column"
    rlRun "dir" 0 "dir list directory"
    rlRun "vdir" 0 "vdir long format list"
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

#!/bin/bash
# Functional test: coreutils - Copy--move--remove--cp--mv--rm--rmdir
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

    rlPhaseStartTest "Copy--move--remove--cp--mv--rm--rmdir"
    rlRun "cp file1.txt file1_copy.txt" 0 "cp copy file"
    rlRun "test -f file1_copy.txt" 0 "cp: verify copy exists"
    rlRun "diff file1.txt file1_copy.txt" 0 "cp: files identical"
    rlRun "cp -r ls_testdir ls_testdir_copy" 0 "cp -r recursive copy"
    rlRun "test -d ls_testdir_copy" 0 "cp -r: verify directory copy"
    rlRun "mv file1_copy.txt file1_renamed.txt" 0 "mv rename file"
    rlRun "test ! -f file1_copy.txt" 0 "mv: old name gone"
    rlRun "test -f file1_renamed.txt" 0 "mv: new name exists"
    rlRun "mv file1_renamed.txt subdir_move.txt 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "mv to subdirectory"
    rlRun "touch temp_rm.txt" 0 "Create temp file"
    rlRun "rm temp_rm.txt" 0 "rm remove file"
    rlRun "test ! -f temp_rm.txt" 0 "rm: file removed"
    rlRun "cp -r ls_testdir ls_testdir_rm" 0 "Create dir to remove"
    rlRun "rm -rf ls_testdir_rm" 0 "rm -rf recursive force"
    rlRun "test ! -d ls_testdir_rm" 0 "rm -rf: directory removed"
    rlRun "mkdir rmdir_test" 0 "Create empty directory"
    rlRun "rmdir rmdir_test" 0 "rmdir remove empty directory"
    rlRun "test ! -d rmdir_test" 0 "rmdir: directory removed"
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

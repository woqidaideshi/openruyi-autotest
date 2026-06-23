#!/bin/bash
# Functional test: coreutils - File-operations--dd--truncate--shred--sync--instal
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "File-operations--dd--truncate--shred--sync--instal"
        rlRun "dd if=file1.txt of=dd_out.txt 2>&1" 0 "dd copy file"
        rlRun "truncate -s 100 trunc_test.txt" 0 "truncate set size"
        rlRun "test $(stat -c %s trunc_test.txt) -eq 100" 0 "truncate: verify size"
        rlRun "echo \"secret data\" > shred_test.txt" 0 "Create file to shred"
        rlRun "shred -n 1 -u shred_test.txt" 0 "shred remove file securely"
        rlRun "test ! -f shred_test.txt" 0 "shred: file removed"
        rlRun "sync" 0 "sync flush filesystem buffers"
        rlRun "install -m 644 file1.txt install_dest.txt" 0 "install copy with mode"
        rlRun "test -f install_dest.txt" 0 "install: destination exists"
        rlRun "install -d install_dir" 0 "install -d create directory"
        rlRun "test -d install_dir" 0 "install -d: directory exists"
        rlRun "chroot --version" 0 "chroot version check"
        rlRun "mkfifo mkfifo_pipe" 0 "mkfifo create named pipe"
        rlRun "test -p mkfifo_pipe" 0 "mkfifo: verify pipe created"
        rlRun "mknod --version" 0 "mknod version check"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

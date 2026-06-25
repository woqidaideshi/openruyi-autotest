#!/bin/bash
# Functional test: coreutils - Error-handling
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

    rlPhaseStartTest "Error-handling"
        rlRun "cp nonexistent.txt /tmp/ 2>&1" 1 "cp: error on nonexistent source"
        rlRun "ls nonexistent_file 2>&1" 2 "ls: error on nonexistent file"
        rlRun "mkdir ls_testdir 2>&1" 1 "mkdir: error on existing dir"
        rlRun "rm ls_testdir_copy 2>&1" 1 "rm: error on dir without -r"
        rlRun "rmdir a 2>&1" 1 "rmdir: error on non-empty dir"
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

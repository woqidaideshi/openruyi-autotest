#!/bin/bash
# Functional test: gcc - Multi-file-compilation
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        gccSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Multi-file-compilation"
        rlRun "gcc -c add.c -o add.o" 0 "Compile add.c to object"
        rlRun "gcc -c main.c -o main.o" 0 "Compile main.c to object"
        rlRun "gcc add.o main.o -o multi_bin" 0 "Link multiple objects"
        rlRun "./multi_bin" 0 "Run multi-file program"
        rlRun "gcc add.c main.c -o multi_bin2" 0 "Compile multiple files in one command"
        rlRun "./multi_bin2" 0 "Run single-command multi-file program"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # gcc 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

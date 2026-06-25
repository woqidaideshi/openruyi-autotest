#!/bin/bash
# Functional test: gcc - Basic-C-compilation
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

    rlPhaseStartTest "Basic-C-compilation"
        rlRun "gcc hello.c -o hello" 0 "Compile hello.c to hello"
        rlRun "./hello" 0 "Run compiled hello"
        rlRun "file hello | grep -i elf" 0 "Verify output is ELF binary"
        rlRun "gcc -o myhello hello.c" 0 "Compile with -o flag"
        rlRun "./myhello" 0 "Run myhello"
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

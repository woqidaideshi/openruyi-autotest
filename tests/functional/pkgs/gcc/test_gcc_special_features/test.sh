#!/bin/bash
# Functional test: gcc - Special-features
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

    rlPhaseStartTest "Special-features"
        rlRun "gcc -std=c99 hello.c -o hello_c99" 0 "Compile with C99 standard"
        rlRun "gcc attr.c -o attr_test" 0 "Compile with __attribute__"
        rlRun "./attr_test" 0 "Run attribute test"
        rlRun "gcc -I include_dir main.c include_dir/mylib.c -o include_test" 0 "Compile with -I include path"
        rlRun "./include_test" 0 "Run include path test"
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

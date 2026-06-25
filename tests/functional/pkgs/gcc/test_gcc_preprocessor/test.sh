#!/bin/bash
# Functional test: gcc - Preprocessor
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

    rlPhaseStartTest "Preprocessor"
        rlRun "gcc -E macro.c -o macro.i" 0 "Preprocess with -E"
        rlRun "grep \"Hello Preprocessor\" macro.i" 0 "Verify macro expanded in preprocessed output"
        rlRun "gcc macro.i -o macro_bin" 0 "Compile preprocessed .i file"
        rlRun "./macro_bin" 0 "Run from preprocessed source"
        rlRun "gcc -DTEST_VAL=42 hello.c -o hello_def" 0 "Compile with -D flag"
        rlRun "./hello_def" 0 "Run with -D defined macro"
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

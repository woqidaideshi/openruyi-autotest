#!/bin/bash
# Functional test: gcc - Compiler-optimization-flags
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

    rlPhaseStartTest "Compiler-optimization-flags"
        rlRun "gcc -O0 compute.c -o compute_O0" 0 "Compile with -O0"
        rlRun "gcc -O2 compute.c -o compute_O2" 0 "Compile with -O2"
        rlRun "gcc -g hello.c -o hello_dbg" 0 "Compile with debug symbols -g"
        rlRun "file hello_dbg | grep -q \"debug_info\"" 0 "Verify debug symbols present"
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

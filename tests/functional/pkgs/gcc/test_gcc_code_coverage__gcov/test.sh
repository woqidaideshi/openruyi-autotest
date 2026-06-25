#!/bin/bash
# Functional test: gcc - Code-coverage--gcov
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

    rlPhaseStartTest "Code-coverage--gcov"
        rlRun "gcc -fprofile-arcs -ftest-coverage gcov_test.c -o gcov_test" 0 "Compile with coverage flags"
        rlRun "./gcov_test" 0 "Run coverage test program"
        rlRun "gcov gcov_test.c" 0 "Run gcov"
        rlRun "ls -la gcov_test.c.gcov" 0 "Check gcov output file exists"
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

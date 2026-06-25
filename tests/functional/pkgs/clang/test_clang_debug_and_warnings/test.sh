#!/bin/bash
# Functional test: clang - Debug-and-warnings
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        clangSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Debug-and-warnings"
        rlRun "clang -g -c hello.c -o hello_g.o" 0 "Debug symbols"
        rlRun "clang -Wall -c hello.c -o hello_Wall.o" 0 "-Wall warnings"
        rlRun "clang -Wextra -c hello.c -o hello_Wextra.o" 0 "-Wextra warnings"
        rlRun "clang -Werror -c hello.c -o hello_Werror.o" 0 "-Werror"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # clang 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

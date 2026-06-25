#!/bin/bash
# Functional test: grep - Context-lines---A---B---C
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        grepSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Context-lines---A---B---C"
        rlRun "grep -A1 \"Hello World\" test1.txt" 0 "Context: 1 line after match"
        rlRun "grep -B1 \"Hello Linux\" test1.txt" 0 "Context: 1 line before match"
        rlRun "grep -C1 \"Hello World\" test1.txt" 0 "Context: 1 line before and after"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # grep 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

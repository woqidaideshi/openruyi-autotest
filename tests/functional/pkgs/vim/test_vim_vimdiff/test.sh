#!/bin/bash
# Functional test: vim - Vimdiff
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        vimSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        echo "hello world" > file1.txt
        echo "hello ruyi" > file2.txt
        rlAssertExists "file1.txt"
        rlAssertExists "file2.txt"
    rlPhaseEnd

    rlPhaseStartTest "Vimdiff"
        rlRun "vimdiff -c 'qa!' file1.txt file2.txt 2>&1" 0 "vimdiff: compare files"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # vim 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

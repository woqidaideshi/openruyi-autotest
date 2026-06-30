#!/bin/bash
# Functional test: wget - Verbose-and-quiet-modes
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        wgetSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Verbose-and-quiet-modes"
        rlRun "wget --version -q 2>&1" 0 "wget -q 静默模式"
        rlRun "wget --version -v 2>&1" 0 "wget -v 详细模式"
        rlRun "wget --version -d 2>&1" 0 "wget -d 调试模式"
        rlRun "wget --version --debug 2>&1" 0 "wget --debug 调试模式"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # wget 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

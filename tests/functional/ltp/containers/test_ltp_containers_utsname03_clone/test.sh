#!/bin/bash
# Functional test: ltp - containers - utsname03_clone
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        ltpSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "LTP containers - utsname03_clone"
        rlRun "_ltpRunCase containers utsname03_clone" 0 "执行 LTP utsname03_clone"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
        # LTP 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

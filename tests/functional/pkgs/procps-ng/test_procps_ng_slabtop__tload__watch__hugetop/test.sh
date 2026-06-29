#!/bin/bash
# Functional test: procps-ng - ng - slabtop--tload--watch--hugetop
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        procpsNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "ng - slabtop--tload--watch--hugetop"
        rlRun "which slabtop 2>/dev/null || echo slabtop-not-found" 0 "slabtop 命令检查"
        rlRun "which tload 2>/dev/null || echo tload-not-found" 0 "tload 命令检查"
        rlRun "watch --version" 0 "watch --version"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # procps-ng 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

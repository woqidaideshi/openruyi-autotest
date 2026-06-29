#!/bin/bash
# Functional test: wget2 - Timeouts-and-retries
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        wget2Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Timeouts-and-retries"
        rlRun "wget2 --timeout=1 --version 2>&1 >/dev/null" 1 "wget2 --timeout 选项"
        rlRun "wget2 --connect-timeout=1 --version 2>&1 >/dev/null" 1 "wget2 --connect-timeout 选项"
        rlRun "wget2 --tries=1 --version 2>&1 >/dev/null" 1 "wget2 --tries 选项"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # wget2 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

#!/bin/bash
# Functional test: wget - Timeout-and-retries
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

    rlPhaseStartTest "Timeout-and-retries"
        rlRun "wget --timeout=1 --version 2>&1 | grep -q Wget" 0 "wget --timeout 选项存在"
        rlRun "wget --connect-timeout=1 --version 2>&1 | grep -q Wget" 0 "wget --connect-timeout 选项存在"
        rlRun "wget --dns-timeout=1 --version 2>&1 | grep -q Wget" 0 "wget --dns-timeout 选项存在"
        rlRun "wget --tries=1 --version 2>&1 | grep -q Wget" 0 "wget --tries 选项存在"
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

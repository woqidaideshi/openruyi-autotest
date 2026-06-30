#!/bin/bash
# Functional test: wget2 - Error-handling
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

    rlPhaseStartTest "Error-handling"
        rlRun "wget2 http://127.0.0.1:1/ 2>&1" 2 "wget2 连接拒绝端口应报错"
        rlRun "wget2 http://nonexistent.invalid/ 2>&1" 4 "wget2 无法解析域名应报错"
        rlRun "wget2 --invalid-option 2>&1" 1 "wget2 无效选项应报错"
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

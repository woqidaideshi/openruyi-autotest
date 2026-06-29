#!/bin/bash
# Functional test: filesystem - 错误处理
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        filesystemSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "错误处理"
        rlRun "ls /etc/" 0 "ls 正常目录成功"
        rlRun "ls /nonexistent_12345 2>&1" 2 "ls 不存在的目录应报错"
        rlRun "touch $TmpDir/testfile && test -f $TmpDir/testfile" 0 "touch 和 test -f 基本功能"
        rlRun "test -f /nonexistent_file 2>&1" 1 "test -f 不存在文件应返回 1"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # filesystem 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

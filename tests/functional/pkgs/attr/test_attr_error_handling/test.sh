#!/bin/bash
# Functional test: attr - 错误处理
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        attrSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "错误处理"
        rlRun "TmpDir=$(mktemp -d)" 0 "错误处理ʱ����Ŀ¼"
        rlRun "cd $TmpDir" 0 "错误处理�Ŀ¼"
        rlRun "getfattr nonexistent_file" 1-255 "���Բ错误处理ļ�����"
        rlRun "setfattr -n user.test -v val nonexistent_file" 1-255 "���ԶԲ错误处理ļ错误处理���"
        rlRun "getfattr --invalid-flag nonexistent" 1-255 "错误处理Ч错误处理��"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # attr 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

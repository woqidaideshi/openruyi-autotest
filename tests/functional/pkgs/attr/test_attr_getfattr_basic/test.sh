#!/bin/bash
# Functional test: attr - getfattr 错误处理��
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

    rlPhaseStartTest "getfattr 错误处理��"
        rlRun "TmpDir=$(mktemp -d)" 0 "错误处理ʱ����Ŀ¼"
        rlRun "cd $TmpDir" 0 "错误处理�Ŀ¼"
        rlRun "touch testfile" 0 "错误处理���ļ�"
        rlRun "mkdir testdir" 0 "错误处理��Ŀ¼"
        rlRun "getfattr -d testfile" 0 "�鿴�ļ���չ����"
        rlRun "setfattr -n user.test -v hello testfile" 0 "错误处理չ����"
        rlRun "getfattr -n user.test testfile" 0 "�鿴ָ����չ����"
        rlRun "getfattr -d testfile" 0 "�鿴错误处理չ����"
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

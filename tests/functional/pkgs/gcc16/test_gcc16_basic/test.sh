#!/bin/bash
# Functional test: gcc16 - gcc16 错误处理��
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        gcc16Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "gcc16 错误处理��"
        rlRun "TmpDir=$(mktemp -d)" 0 "错误处理ʱĿ¼"
        rlRun "cd $TmpDir" 0 "错误处理�Ŀ¼"
        rlRun "echo \"int main(){return 0;}\" > test.c" 0 "错误处理��Դ��"
        rlRun "gcc-16 -o test test.c" 0 "���� C ����"
        rlRun "./test" 0 "���б����ĳ���"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # gcc16 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

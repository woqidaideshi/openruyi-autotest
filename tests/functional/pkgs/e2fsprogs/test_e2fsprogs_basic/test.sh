#!/bin/bash
# Functional test: e2fsprogs - e2fsprogs ��������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        e2fsprogsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "e2fsprogs ��������"
        rlRun "TmpDir=$(mktemp -d)" 0 "������ʱĿ¼"
        rlRun "cd $TmpDir" 0 "�������Ŀ¼"
        rlRun "dd if=/dev/zero of=test.img bs=1M count=10" 0 "�������Ծ���"
        rlRun "mke2fs -F test.img" 0 "���� ext2 �ļ�ϵͳ"
        rlRun "dumpe2fs test.img 2>&1 | head -10" 0 "�鿴�ļ�ϵͳ��Ϣ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # e2fsprogs 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

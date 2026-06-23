#!/bin/bash
# Functional test: bzip2 - ѹ������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        bzip2Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "ѹ������"
        rlRun "TmpDir=$(mktemp -d)" 0 "������ʱĿ¼"
        rlRun "cd $TmpDir" 0 "�������Ŀ¼"
        rlRun "echo \"test data for bzip2\" > testfile" 0 "���������ļ�"
        rlRun "bzip2 -k testfile" 0 "ѹ���ļ�(����ԭ�ļ�)"
        rlRun "test -f testfile.bz2" 0 "��֤ѹ���ļ�����"
        rlRun "bunzip2 -k testfile.bz2" 0 "��ѹ�ļ�(����ѹ���ļ�)"
        rlRun "bzip2 testfile" 0 "ѹ���ļ�(ɾ��ԭ�ļ�)"
        rlRun "test -f testfile.bz2" 0 "��֤ѹ���ļ�����"
        rlRun "bunzip2 testfile.bz2" 0 "��ѹ�ļ�"
        rlRun "test -f testfile" 0 "��֤��ѹ���ļ�����"
        rlRun "echo \"hello bzip2\" | bzip2 > test2.bz2" 0 "ͨ���ܵ�ѹ��"
        rlRun "bzcat test2.bz2" 0 "�鿴ѹ���ļ�����"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # bzip2 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

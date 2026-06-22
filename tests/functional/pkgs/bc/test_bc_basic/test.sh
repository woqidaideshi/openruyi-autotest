#!/bin/bash
# Functional test: bc - ��������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        bcSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "��������"
        rlRun "echo \"1+1\" | bc" 0 "�����ӷ�"
        rlRun "echo \"10-3\" | bc" 0 "��������"
        rlRun "echo \"6*7\" | bc" 0 "�����˷�"
        rlRun "echo \"100/3\" | bc" 0 "��������"
        rlRun "echo \"scale=4; 1/3\" | bc" 0 "���þ���"
        rlRun "echo \"2^10\" | bc" 0 "������"
        rlRun "echo \"sqrt(16)\" | bc" 0 "ƽ����"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # bc 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

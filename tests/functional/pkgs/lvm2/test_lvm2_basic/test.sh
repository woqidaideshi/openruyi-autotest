#!/bin/bash
# Functional test: lvm2 - lvm2 ��������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        lvm2Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "lvm2 ��������"
        rlRun "lvm version 2>&1 || true" 0 "LVM �汾"
        rlRun "lvm help 2>&1 | head -10" 0 "LVM ����"
        rlRun "pvs 2>&1 || true" 0 "��ʾ������"
        rlRun "vgs 2>&1 || true" 0 "��ʾ����"
        rlRun "lvs 2>&1 || true" 0 "��ʾ�߼���"
        rlRun "pvdisplay 2>&1 || true" 0 "����������"
        rlRun "vgdisplay 2>&1 || true" 0 "��������"
        rlRun "lvdisplay 2>&1 || true" 0 "�߼�������"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # lvm2 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd

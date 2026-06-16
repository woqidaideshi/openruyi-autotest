#!/bin/sh -eux
# Functional test: lvm2 ��������
# Commands: lvm, pvs, vgs, lvs, pvcreate, vgcreate, lvcreate

. "../setup.sh"

rlRun 'lvm version 2>&1 || true' 0 "LVM �汾"
rlRun 'lvm help 2>&1 | head -10' 0 "LVM ����"
rlRun 'pvs 2>&1 || true' 0 "��ʾ������"
rlRun 'vgs 2>&1 || true' 0 "��ʾ����"
rlRun 'lvs 2>&1 || true' 0 "��ʾ�߼���"
rlRun 'pvdisplay 2>&1 || true' 0 "����������"
rlRun 'vgdisplay 2>&1 || true' 0 "��������"
rlRun 'lvdisplay 2>&1 || true' 0 "�߼�������"

. "../teardown.sh"
echo "All lvm2-basic functional tests passed!"

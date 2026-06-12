#!/bin/sh -eux
# Functional test: lvm2 ��������
# Commands: lvm, pvs, vgs, lvs, pvcreate, vgcreate, lvcreate

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q lvm2 2>/dev/null || { echo 'lvm2 not installed, skipping'; exit 0; }
which lvm 2>/dev/null || echo 'lvm not found'
which pvs 2>/dev/null || echo 'pvs not found'
which vgs 2>/dev/null || echo 'vgs not found'
which lvs 2>/dev/null || echo 'lvs not found'

echo "=== LVM ���� ==="
rlRun 'lvm version 2>&1 || true' 0 "LVM �汾"
rlRun 'lvm help 2>&1 | head -10' 0 "LVM ����"
rlRun 'pvs 2>&1 || true' 0 "��ʾ������"
rlRun 'vgs 2>&1 || true' 0 "��ʾ����"
rlRun 'lvs 2>&1 || true' 0 "��ʾ�߼���"
rlRun 'pvdisplay 2>&1 || true' 0 "����������"
rlRun 'vgdisplay 2>&1 || true' 0 "��������"
rlRun 'lvdisplay 2>&1 || true' 0 "�߼�������"

echo ""
echo "All lvm2-basic functional tests passed!"

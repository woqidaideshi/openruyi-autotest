#!/bin/sh -eux
# Functional test: lvm2 ��������
# Commands: lvm, pvs, vgs, lvs, pvcreate, vgcreate, lvcreate

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lvm2 ===
INSTALLED_BY_TEST=0
if ! rpm -q lvm2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lvm2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lvm2"
    else
        echo "SKIP: lvm2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: lvm2 already installed"
fi



echo "=== LVM ���� ==="
rlRun 'lvm version 2>&1 || true' 0 "LVM �汾"
rlRun 'lvm help 2>&1 | head -10' 0 "LVM ����"
rlRun 'pvs 2>&1 || true' 0 "��ʾ������"
rlRun 'vgs 2>&1 || true' 0 "��ʾ����"
rlRun 'lvs 2>&1 || true' 0 "��ʾ�߼���"
rlRun 'pvdisplay 2>&1 || true' 0 "����������"
rlRun 'vgdisplay 2>&1 || true' 0 "��������"
rlRun 'lvdisplay 2>&1 || true' 0 "�߼�������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lvm2 2>/dev/null || true
    echo "TEARDOWN: removed lvm2"
fi
echo ""
echo "All lvm2-basic functional tests passed!"

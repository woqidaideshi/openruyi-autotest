#!/bin/sh -eux
# Functional test: e2fsprogs ��������
# Commands: e2fsck, mke2fs, tune2fs, dumpe2fs

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install e2fsprogs ===
INSTALLED_BY_TEST=0
if ! rpm -q e2fsprogs 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y e2fsprogs 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed e2fsprogs"
    else
        echo "SKIP: e2fsprogs not available in repos"
        exit 0
    fi
else
    echo "SETUP: e2fsprogs already installed"
fi



echo "=== ������Ϣ ==="
rlRun 'e2fsck --help 2>&1 | head -10' 0 "e2fsck ����"
rlRun 'mke2fs --help 2>&1 | head -10' 0 "mke2fs ����"
rlRun 'tune2fs --help 2>&1 | head -10' 0 "tune2fs ����"
rlRun 'dumpe2fs --help 2>&1 | head -10' 0 "dumpe2fs ����"
rlRun 'resize2fs --help 2>&1 | head -10' 0 "resize2fs ����"

echo "=== mke2fs �����ļ�ϵͳ ==="
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'dd if=/dev/zero of=test.img bs=1M count=10' 0 "�������Ծ���"
rlRun 'mke2fs -F test.img' 0 "���� ext2 �ļ�ϵͳ"
rlRun 'dumpe2fs test.img 2>&1 | head -10' 0 "�鿴�ļ�ϵͳ��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y e2fsprogs 2>/dev/null || true
    echo "TEARDOWN: removed e2fsprogs"
fi
echo ""
echo "All e2fsprogs-basic functional tests passed!"

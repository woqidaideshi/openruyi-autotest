#!/bin/sh -eux
# Functional test: e2fsprogs ��������
# Commands: e2fsck, mke2fs, tune2fs, dumpe2fs

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q e2fsprogs 2>/dev/null || { echo 'e2fsprogs not installed, skipping'; exit 0; }
which e2fsck 2>/dev/null || echo 'e2fsck not found'
which mke2fs 2>/dev/null || echo 'mke2fs not found'
which tune2fs 2>/dev/null || echo 'tune2fs not found'
which dumpe2fs 2>/dev/null || echo 'dumpe2fs not found'

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

echo ""
echo "All e2fsprogs-basic functional tests passed!"

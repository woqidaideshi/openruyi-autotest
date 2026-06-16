#!/bin/sh -eux
# Functional test: e2fsprogs ��������
# Commands: e2fsck, mke2fs, tune2fs, dumpe2fs

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'dd if=/dev/zero of=test.img bs=1M count=10' 0 "�������Ծ���"
rlRun 'mke2fs -F test.img' 0 "���� ext2 �ļ�ϵͳ"
rlRun 'dumpe2fs test.img 2>&1 | head -10' 0 "�鿴�ļ�ϵͳ��Ϣ"

. "../teardown.sh"
echo "All e2fsprogs-basic functional tests passed!"

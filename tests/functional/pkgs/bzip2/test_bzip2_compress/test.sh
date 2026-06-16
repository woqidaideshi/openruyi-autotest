#!/bin/sh -eux
# Functional test: bzip2 - ѹ������
# Commands: bzip2, bunzip2

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== bzip2 ѹ����ѹ ==="
rlRun 'echo "test data for bzip2" > testfile' 0 "���������ļ�"
rlRun 'bzip2 -k testfile' 0 "ѹ���ļ�(����ԭ�ļ�)"
rlRun 'test -f testfile.bz2' 0 "��֤ѹ���ļ�����"
rlRun 'bunzip2 -k testfile.bz2' 0 "��ѹ�ļ�(����ѹ���ļ�)"
rlRun 'bzip2 testfile' 0 "ѹ���ļ�(ɾ��ԭ�ļ�)"
rlRun 'test -f testfile.bz2' 0 "��֤ѹ���ļ�����"
rlRun 'bunzip2 testfile.bz2' 0 "��ѹ�ļ�"
rlRun 'test -f testfile' 0 "��֤��ѹ���ļ�����"

echo "=== bzcat �鿴ѹ������ ==="
rlRun 'echo "hello bzip2" | bzip2 > test2.bz2' 0 "ͨ���ܵ�ѹ��"
rlRun 'bzcat test2.bz2' 0 "�鿴ѹ���ļ�����"

. "../teardown.sh"
echo "All bzip2-compress functional tests passed!"

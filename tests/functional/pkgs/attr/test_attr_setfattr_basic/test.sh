#!/bin/sh -eux
# Functional test: attr - setfattr ��������
# Tests: setfattr commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'touch testfile' 0 "���������ļ�"
rlRun 'mkdir testdir' 0 "��������Ŀ¼"

echo "=== ����: setfattr �������� ==="
rlRun 'setfattr -n user.test -v hello testfile' 0 "������չ����"
rlRun 'getfattr -n user.test testfile' 0 "��֤���óɹ�"
rlRun 'setfattr -n user.test2 -v world testfile' 0 "���õڶ�����չ����"
rlRun 'getfattr -d testfile' 0 "�鿴�����չ����"
rlRun 'setfattr -x user.test testfile' 0 "ɾ����չ����"
rlRun 'setfattr -x user.test2 testfile' 0 "ɾ���ڶ�����չ����"

. "../teardown.sh"
echo "All attr-setfattr-basic functional tests passed!"

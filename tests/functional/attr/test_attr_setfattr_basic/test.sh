#!/bin/sh -eux
# Functional test: attr - setfattr ��������
# Tests: setfattr commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q attr 2>/dev/null || { echo 'attr not installed, skipping'; exit 0; }
which setfattr 2>/dev/null || echo 'setfattr not found'
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

echo ""
echo "All attr-setfattr-basic functional tests passed!"

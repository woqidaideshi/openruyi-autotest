#!/bin/sh -eux
# Functional test: attr - getfattr ��������
# Tests: getfattr commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q attr 2>/dev/null || { echo 'attr not installed, skipping'; exit 0; }
which getfattr 2>/dev/null || echo 'getfattr not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'touch testfile' 0 "���������ļ�"
rlRun 'mkdir testdir' 0 "��������Ŀ¼"

echo "=== ����: getfattr �������� ==="
rlRun 'getfattr -d testfile' 0 "�鿴�ļ���չ����"
rlRun 'setfattr -n user.test -v hello testfile' 0 "������չ����"
rlRun 'getfattr -n user.test testfile' 0 "�鿴ָ����չ����"
rlRun 'getfattr -d testfile' 0 "�鿴������չ����"

echo ""
echo "All attr-getfattr-basic functional tests passed!"

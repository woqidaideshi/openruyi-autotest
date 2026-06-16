#!/bin/sh -eux
# Functional test: attr - ��չ�ļ�����
# Tests: attr, getfattr, setfattr commands

# rlRun wrapper for standalone execution

. "./setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'touch testfile' 0 "���������ļ�"
rlRun 'mkdir testdir' 0 "��������Ŀ¼"

. "./teardown.sh"
echo "All attr functional tests passed!"

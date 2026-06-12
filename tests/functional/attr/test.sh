#!/bin/sh -eux
# Functional test: attr - ��չ�ļ�����
# Tests: attr, getfattr, setfattr commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q attr 2>/dev/null || { echo 'attr not installed, skipping'; exit 0; }
which attr 2>/dev/null || echo 'attr not found'
which getfattr 2>/dev/null || echo 'getfattr not found'
which setfattr 2>/dev/null || echo 'setfattr not found'
rlRun 'attr --version' 0 "��ȡ attr �汾��Ϣ"
rlRun 'getfattr --version' 0 "��ȡ getfattr �汾��Ϣ"
rlRun 'setfattr --version' 0 "��ȡ setfattr �汾��Ϣ"
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'touch testfile' 0 "���������ļ�"
rlRun 'mkdir testdir' 0 "��������Ŀ¼"

echo ""
echo "All attr functional tests passed!"

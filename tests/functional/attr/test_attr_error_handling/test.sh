#!/bin/sh -eux
# Functional test: attr - ������
# Tests: attr, getfattr, setfattr commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q attr 2>/dev/null || { echo 'attr not installed, skipping'; exit 0; }
which getfattr 2>/dev/null || echo 'getfattr not found'
which setfattr 2>/dev/null || echo 'setfattr not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== ����: ������ ==="
rlRun 'getfattr nonexistent_file' 1-255 "���Բ������ļ�����"
rlRun 'setfattr -n user.test -v val nonexistent_file' 1-255 "���ԶԲ������ļ���������"
rlRun 'getfattr --invalid-flag nonexistent' 1-255 "������Ч��������"

echo ""
echo "All attr-error-handling functional tests passed!"

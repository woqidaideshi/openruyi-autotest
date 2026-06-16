#!/bin/sh -eux
# Functional test: attr - ������
# Tests: attr, getfattr, setfattr commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== ����: ������ ==="
rlRun 'getfattr nonexistent_file' 1-255 "���Բ������ļ�����"
rlRun 'setfattr -n user.test -v val nonexistent_file' 1-255 "���ԶԲ������ļ���������"
rlRun 'getfattr --invalid-flag nonexistent' 1-255 "������Ч��������"

. "../teardown.sh"
echo "All attr-error-handling functional tests passed!"

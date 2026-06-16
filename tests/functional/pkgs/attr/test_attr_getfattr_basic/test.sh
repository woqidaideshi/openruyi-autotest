#!/bin/sh -eux
# Functional test: attr - getfattr ��������
# Tests: getfattr commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install attr ===
INSTALLED_BY_TEST=0
if ! rpm -q attr 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y attr 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed attr"
    else
        echo "SKIP: attr not available in repos"
        exit 0
    fi
else
    echo "SETUP: attr already installed"
fi


rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱ����Ŀ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'touch testfile' 0 "���������ļ�"
rlRun 'mkdir testdir' 0 "��������Ŀ¼"

echo "=== ����: getfattr �������� ==="
rlRun 'getfattr -d testfile' 0 "�鿴�ļ���չ����"
rlRun 'setfattr -n user.test -v hello testfile' 0 "������չ����"
rlRun 'getfattr -n user.test testfile' 0 "�鿴ָ����չ����"
rlRun 'getfattr -d testfile' 0 "�鿴������չ����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y attr 2>/dev/null || true
    echo "TEARDOWN: removed attr"
fi
echo ""
echo "All attr-getfattr-basic functional tests passed!"

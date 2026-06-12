#!/bin/sh -eux
# Functional test: bzip2 - ѹ������
# Commands: bzip2, bunzip2

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bzip2 ===
INSTALLED_BY_TEST=0
if ! rpm -q bzip2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bzip2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bzip2"
    else
        echo "SKIP: bzip2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: bzip2 already installed"
fi


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


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bzip2 2>/dev/null || true
    echo "TEARDOWN: removed bzip2"
fi
echo ""
echo "All bzip2-compress functional tests passed!"

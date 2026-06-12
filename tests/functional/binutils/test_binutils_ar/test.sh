#!/bin/sh -eux
# Functional test: binutils - ar
# Commands: ar

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install binutils ===
INSTALLED_BY_TEST=0
if ! rpm -q binutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y binutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed binutils"
    else
        echo "SKIP: binutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: binutils already installed"
fi


rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== ar �鵵 ==="
rlRun 'echo "test" > file1.txt' 0 "�����ļ�1"
rlRun 'echo "data" > file2.txt' 0 "�����ļ�2"
rlRun 'ar cr test.a file1.txt file2.txt' 0 "�����鵵"
rlRun 'test -f test.a' 0 "��֤�鵵����"
rlRun 'ar t test.a' 0 "�г��鵵����"
rlRun 'ar x test.a' 0 "����鵵"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y binutils 2>/dev/null || true
    echo "TEARDOWN: removed binutils"
fi
echo ""
echo "All binutils-ar functional tests passed!"

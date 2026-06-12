#!/bin/sh -eux
# Functional test: binutils - ar
# Commands: ar

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which ar 2>/dev/null || echo 'ar not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== ar �鵵 ==="
rlRun 'echo "test" > file1.txt' 0 "�����ļ�1"
rlRun 'echo "data" > file2.txt' 0 "�����ļ�2"
rlRun 'ar cr test.a file1.txt file2.txt' 0 "�����鵵"
rlRun 'test -f test.a' 0 "��֤�鵵����"
rlRun 'ar t test.a' 0 "�г��鵵����"
rlRun 'ar x test.a' 0 "����鵵"

echo ""
echo "All binutils-ar functional tests passed!"

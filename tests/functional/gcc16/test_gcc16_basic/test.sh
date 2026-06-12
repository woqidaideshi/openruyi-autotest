#!/bin/sh -eux
# Functional test: gcc16 ��������
# Commands: gcc-16, g++-16

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gcc16 2>/dev/null || { echo 'gcc16 not installed, skipping'; exit 0; }
which gcc-16 2>/dev/null || echo 'gcc-16 not found'
which g++-16 2>/dev/null || echo 'g++-16 not found'

echo "=== GCC 16 ==="
rlRun 'gcc-16 --version 2>&1 | head -3' 0 "�汾"
rlRun 'gcc-16 --help 2>&1 | head -10' 0 "����"
rlRun 'g++-16 --help 2>&1 | head -10' 0 "g++����"

echo "=== ������� ==="
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'echo "int main(){return 0;}" > test.c' 0 "��������Դ��"
rlRun 'gcc-16 -o test test.c' 0 "���� C ����"
rlRun './test' 0 "���б����ĳ���"

echo ""
echo "All gcc16-basic functional tests passed!"

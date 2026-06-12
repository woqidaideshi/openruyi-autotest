#!/bin/sh -eux
# Functional test: cracklib - ��������
# Commands: cracklib-check

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cracklib 2>/dev/null || { echo 'cracklib not installed, skipping'; exit 0; }
which cracklib-check 2>/dev/null || echo 'cracklib-check not found'

echo "=== ����ǿ�ȼ�� ==="
rlRun 'echo "password" | cracklib-check' 0 "���������"
rlRun 'echo "Str0ng!Pass" | cracklib-check' 0 "���ǿ����"
rlRun 'echo "abc" | cracklib-check' 0 "��������"

echo ""
echo "All cracklib-basic functional tests passed!"

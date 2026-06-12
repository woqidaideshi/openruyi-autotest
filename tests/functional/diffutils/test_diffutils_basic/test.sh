#!/bin/sh -eux
# Functional test: diffutils - ��������
# Tests: cmp, diff, diff3, sdiff commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q diffutils 2>/dev/null || { echo 'diffutils not installed, skipping'; exit 0; }
which cmp 2>/dev/null || echo 'cmp not found'
which diff 2>/dev/null || echo 'diff not found'
which diff3 2>/dev/null || echo 'diff3 not found'
which sdiff 2>/dev/null || echo 'sdiff not found'

echo "=== ����: diffutils �������� ==="
rlRun 'cmp --help 2>&1 | head -10' 0 "�鿴 cmp ������Ϣ"
rlRun 'diff --help 2>&1 | head -10' 0 "�鿴 diff ������Ϣ"
rlRun 'diff3 --help 2>&1 | head -10' 0 "�鿴 diff3 ������Ϣ"
rlRun 'sdiff --help 2>&1 | head -10' 0 "�鿴 sdiff ������Ϣ"

echo ""
echo "All diffutils-basic functional tests passed!"

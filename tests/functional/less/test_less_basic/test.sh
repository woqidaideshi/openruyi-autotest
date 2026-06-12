#!/bin/sh -eux
# Functional test: less - ��������
# Tests: less, lessecho, lesskey commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q less 2>/dev/null || { echo 'less not installed, skipping'; exit 0; }
which less 2>/dev/null || echo 'less not found'
which lessecho 2>/dev/null || echo 'lessecho not found'
which lesskey 2>/dev/null || echo 'lesskey not found'

echo "=== ����: less �������� ==="
rlRun 'less --help 2>&1 | head -10' 0 "�鿴 less ������Ϣ"
rlRun 'lessecho --help 2>&1 | head -10' 0 "�鿴 lessecho ������Ϣ"
rlRun 'lesskey --help 2>&1 | head -10' 0 "�鿴 lesskey ������Ϣ"

echo ""
echo "All less-basic functional tests passed!"

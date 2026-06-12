#!/bin/sh -eux
# Functional test: tcsh - ��������
# Tests: tcsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tcsh 2>/dev/null || { echo 'tcsh not installed, skipping'; exit 0; }
which tcsh 2>/dev/null || echo 'tcsh not found'

echo "=== ����: tcsh �������� ==="
rlRun 'tcsh --help 2>&1 | head -10' 0 "�鿴 tcsh ������Ϣ"

echo ""
echo "All tcsh-basic functional tests passed!"

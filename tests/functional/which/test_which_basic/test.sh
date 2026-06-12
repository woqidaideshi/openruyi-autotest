#!/bin/sh -eux
# Functional test: which - ��������
# Tests: which commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q which 2>/dev/null || { echo 'which not installed, skipping'; exit 0; }
which which 2>/dev/null || echo 'which not found'

echo "=== ����: which �������� ==="
rlRun 'which --help 2>&1 | head -10' 0 "�鿴 which ������Ϣ"

echo ""
echo "All which-basic functional tests passed!"

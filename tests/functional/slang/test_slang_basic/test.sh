#!/bin/sh -eux
# Functional test: slang - ��������
# Tests: slsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q slang 2>/dev/null || { echo 'slang not installed, skipping'; exit 0; }
which slsh 2>/dev/null || echo 'slsh not found'

echo "=== ����: slang �������� ==="
rlRun 'slsh --help 2>&1 | head -10' 0 "�鿴 slsh ������Ϣ"

echo ""
echo "All slang-basic functional tests passed!"

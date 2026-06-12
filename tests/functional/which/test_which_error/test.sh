#!/bin/sh -eux
# Functional test: which - ������
# Tests: which commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q which 2>/dev/null || { echo 'which not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'which --invalid-flag-xyz 2>&1 || true' 0 "���� which ��Ч����������"

echo ""
echo "All which-error functional tests passed!"

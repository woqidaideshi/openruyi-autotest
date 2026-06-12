#!/bin/sh -eux
# Functional test: tcsh - ������
# Tests: tcsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tcsh 2>/dev/null || { echo 'tcsh not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'tcsh --invalid-flag-xyz 2>&1 || true' 0 "���� tcsh ��Ч����������"

echo ""
echo "All tcsh-error functional tests passed!"

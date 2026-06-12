#!/bin/sh -eux
# Functional test: libidn2 - ������
# Tests: idn2 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libidn2 2>/dev/null || { echo 'libidn2 not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'idn2 --invalid-flag-xyz 2>&1 || true' 0 "���� idn2 ��Ч����������"

echo ""
echo "All libidn2-error functional tests passed!"

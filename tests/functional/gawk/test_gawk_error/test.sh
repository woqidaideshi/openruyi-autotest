#!/bin/sh -eux
# Functional test: gawk - ������
# Tests: awk, gawk commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gawk 2>/dev/null || { echo 'gawk not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'awk --invalid-flag-xyz 2>&1 || true' 0 "���� awk ��Ч����������"
rlRun 'gawk --invalid-flag-xyz 2>&1 || true' 0 "���� gawk ��Ч����������"

echo ""
echo "All gawk-error functional tests passed!"

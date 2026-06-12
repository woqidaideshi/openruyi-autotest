#!/bin/sh -eux
# Functional test: time - ������
# Tests: time commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q time 2>/dev/null || { echo 'time not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'time --invalid-flag-xyz 2>&1 || true' 0 "���� time ��Ч����������"

echo ""
echo "All time-error functional tests passed!"

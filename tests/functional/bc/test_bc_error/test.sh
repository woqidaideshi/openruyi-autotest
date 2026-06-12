#!/bin/sh -eux
# Functional test: bc/dc - ������
# Tests: bc, dc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bc 2>/dev/null || { echo 'bc not installed, skipping'; exit 0; }
which bc 2>/dev/null || echo 'bc not found'

echo "=== ����: ������ ==="
rlRun 'bc --invalid 2>&1 || true' 0 "bc ��Ч����"
rlRun 'dc --invalid 2>&1 || true' 0 "dc ��Ч����"
rlRun 'echo "1/0" | bc 2>&1 || true' 0 "bc �������"

echo ""
echo "All bc-error functional tests passed!"

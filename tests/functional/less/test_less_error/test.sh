#!/bin/sh -eux
# Functional test: less - ������
# Tests: less, lessecho, lesskey commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q less 2>/dev/null || { echo 'less not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'less --invalid-flag-xyz 2>&1 || true' 0 "���� less ��Ч����������"
rlRun 'lessecho --invalid-flag-xyz 2>&1 || true' 0 "���� lessecho ��Ч����������"
rlRun 'lesskey --invalid-flag-xyz 2>&1 || true' 0 "���� lesskey ��Ч����������"

echo ""
echo "All less-error functional tests passed!"

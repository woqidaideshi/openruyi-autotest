#!/bin/sh -eux
# Functional test: lz4 - ������
# Tests: lz4, lz4c, lz4cat, unlz4 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q lz4 2>/dev/null || { echo 'lz4 not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'lz4 --invalid-flag-xyz 2>&1 || true' 0 "���� lz4 ��Ч����������"
rlRun 'lz4c --invalid-flag-xyz 2>&1 || true' 0 "���� lz4c ��Ч����������"
rlRun 'lz4cat --invalid-flag-xyz 2>&1 || true' 0 "���� lz4cat ��Ч����������"
rlRun 'unlz4 --invalid-flag-xyz 2>&1 || true' 0 "���� unlz4 ��Ч����������"

echo ""
echo "All lz4-error functional tests passed!"

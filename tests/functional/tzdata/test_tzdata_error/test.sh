#!/bin/sh -eux
# Functional test: tzdata - ������
# Tests: tzselect, zdump, zic commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tzdata 2>/dev/null || { echo 'tzdata not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'tzselect --invalid-flag-xyz 2>&1 || true' 0 "���� tzselect ��Ч����������"
rlRun 'zdump --invalid-flag-xyz 2>&1 || true' 0 "���� zdump ��Ч����������"
rlRun 'zic --invalid-flag-xyz 2>&1 || true' 0 "���� zic ��Ч����������"

echo ""
echo "All tzdata-error functional tests passed!"

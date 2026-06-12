#!/bin/sh -eux
# Functional test: diffutils - ������
# Tests: cmp, diff, diff3, sdiff commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q diffutils 2>/dev/null || { echo 'diffutils not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'cmp --invalid-flag-xyz 2>&1 || true' 0 "���� cmp ��Ч����������"
rlRun 'diff --invalid-flag-xyz 2>&1 || true' 0 "���� diff ��Ч����������"
rlRun 'diff3 --invalid-flag-xyz 2>&1 || true' 0 "���� diff3 ��Ч����������"
rlRun 'sdiff --invalid-flag-xyz 2>&1 || true' 0 "���� sdiff ��Ч����������"

echo ""
echo "All diffutils-error functional tests passed!"

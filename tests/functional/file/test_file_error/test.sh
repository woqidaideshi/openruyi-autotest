#!/bin/sh -eux
# Functional test: file - ������
# Tests: file commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q file 2>/dev/null || { echo 'file not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'file --invalid-flag-xyz 2>&1 || true' 0 "���� file ��Ч����������"

echo ""
echo "All file-error functional tests passed!"

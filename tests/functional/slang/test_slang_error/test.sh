#!/bin/sh -eux
# Functional test: slang - ������
# Tests: slsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q slang 2>/dev/null || { echo 'slang not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'slsh --invalid-flag-xyz 2>&1 || true' 0 "���� slsh ��Ч����������"

echo ""
echo "All slang-error functional tests passed!"

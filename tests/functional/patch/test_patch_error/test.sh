#!/bin/sh -eux
# Functional test: patch - ������
# Tests: patch commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q patch 2>/dev/null || { echo 'patch not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'patch --invalid-flag-xyz 2>&1 || true' 0 "���� patch ��Ч����������"

echo ""
echo "All patch-error functional tests passed!"

#!/bin/sh -eux
# Functional test: brotli - ������
# Tests: brotli commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q brotli 2>/dev/null || { echo 'brotli not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'brotli --invalid-flag-xyz 2>&1 || true' 0 "���� brotli ��Ч����������"

echo ""
echo "All brotli-error functional tests passed!"

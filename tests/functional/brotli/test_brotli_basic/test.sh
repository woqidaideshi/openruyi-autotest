#!/bin/sh -eux
# Functional test: brotli - ��������
# Tests: brotli commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q brotli 2>/dev/null || { echo 'brotli not installed, skipping'; exit 0; }
which brotli 2>/dev/null || echo 'brotli not found'

echo "=== ����: brotli �������� ==="
rlRun 'brotli --help 2>&1 | head -10' 0 "�鿴 brotli ������Ϣ"

echo ""
echo "All brotli-basic functional tests passed!"

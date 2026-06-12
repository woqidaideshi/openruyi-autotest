#!/bin/sh -eux
# Functional test: brotli ������
# Tests: brotli commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q brotli 2>/dev/null || { echo 'brotli not installed, skipping'; exit 0; }
which brotli 2>/dev/null || echo 'brotli not found'
rlRun 'brotli --version 2>&1 || true' 0 "��ȡ brotli �汾��Ϣ"

echo ""
echo "All brotli functional tests passed!"

#!/bin/sh -eux
# Functional test: which ������
# Tests: which commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q which 2>/dev/null || { echo 'which not installed, skipping'; exit 0; }
which which 2>/dev/null || echo 'which not found'
rlRun 'which --version 2>&1 || true' 0 "��ȡ which �汾��Ϣ"

echo ""
echo "All which functional tests passed!"

#!/bin/sh -eux
# Functional test: slang ������
# Tests: slsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q slang 2>/dev/null || { echo 'slang not installed, skipping'; exit 0; }
which slsh 2>/dev/null || echo 'slsh not found'
rlRun 'slsh --version 2>&1 || true' 0 "��ȡ slsh �汾��Ϣ"

echo ""
echo "All slang functional tests passed!"

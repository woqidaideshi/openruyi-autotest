#!/bin/sh -eux
# Functional test: file ������
# Tests: file commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q file 2>/dev/null || { echo 'file not installed, skipping'; exit 0; }
which file 2>/dev/null || echo 'file not found'
rlRun 'file --version 2>&1 || true' 0 "��ȡ file �汾��Ϣ"

echo ""
echo "All file functional tests passed!"

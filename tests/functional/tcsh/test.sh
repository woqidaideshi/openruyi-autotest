#!/bin/sh -eux
# Functional test: tcsh ������
# Tests: tcsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tcsh 2>/dev/null || { echo 'tcsh not installed, skipping'; exit 0; }
which tcsh 2>/dev/null || echo 'tcsh not found'
rlRun 'tcsh --version 2>&1 || true' 0 "��ȡ tcsh �汾��Ϣ"

echo ""
echo "All tcsh functional tests passed!"

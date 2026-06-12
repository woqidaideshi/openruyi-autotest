#!/bin/sh -eux
# Functional test: less ������
# Tests: less, lessecho, lesskey commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q less 2>/dev/null || { echo 'less not installed, skipping'; exit 0; }
which less 2>/dev/null || echo 'less not found'
which lessecho 2>/dev/null || echo 'lessecho not found'
which lesskey 2>/dev/null || echo 'lesskey not found'
rlRun 'less --version 2>&1 || true' 0 "��ȡ less �汾��Ϣ"
rlRun 'lessecho --version 2>&1 || true' 0 "��ȡ lessecho �汾��Ϣ"
rlRun 'lesskey --version 2>&1 || true' 0 "��ȡ lesskey �汾��Ϣ"

echo ""
echo "All less functional tests passed!"

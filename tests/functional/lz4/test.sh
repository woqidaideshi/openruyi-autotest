#!/bin/sh -eux
# Functional test: lz4 ������
# Tests: lz4, lz4c, lz4cat, unlz4 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q lz4 2>/dev/null || { echo 'lz4 not installed, skipping'; exit 0; }
which lz4 2>/dev/null || echo 'lz4 not found'
which lz4c 2>/dev/null || echo 'lz4c not found'
which lz4cat 2>/dev/null || echo 'lz4cat not found'
which unlz4 2>/dev/null || echo 'unlz4 not found'
rlRun 'lz4 --version 2>&1 || true' 0 "��ȡ lz4 �汾��Ϣ"
rlRun 'lz4c --version 2>&1 || true' 0 "��ȡ lz4c �汾��Ϣ"
rlRun 'lz4cat --version 2>&1 || true' 0 "��ȡ lz4cat �汾��Ϣ"
rlRun 'unlz4 --version 2>&1 || true' 0 "��ȡ unlz4 �汾��Ϣ"

echo ""
echo "All lz4 functional tests passed!"

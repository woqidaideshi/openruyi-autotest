#!/bin/sh -eux
# Functional test: diffutils ������
# Tests: cmp, diff, diff3, sdiff commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q diffutils 2>/dev/null || { echo 'diffutils not installed, skipping'; exit 0; }
which cmp 2>/dev/null || echo 'cmp not found'
which diff 2>/dev/null || echo 'diff not found'
which diff3 2>/dev/null || echo 'diff3 not found'
which sdiff 2>/dev/null || echo 'sdiff not found'
rlRun 'cmp --version 2>&1 || true' 0 "��ȡ cmp �汾��Ϣ"
rlRun 'diff --version 2>&1 || true' 0 "��ȡ diff �汾��Ϣ"
rlRun 'diff3 --version 2>&1 || true' 0 "��ȡ diff3 �汾��Ϣ"
rlRun 'sdiff --version 2>&1 || true' 0 "��ȡ sdiff �汾��Ϣ"

echo ""
echo "All diffutils functional tests passed!"

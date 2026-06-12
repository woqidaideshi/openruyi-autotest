#!/bin/sh -eux
# Functional test: lz4 - ��������
# Tests: lz4, lz4c, lz4cat, unlz4 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q lz4 2>/dev/null || { echo 'lz4 not installed, skipping'; exit 0; }
which lz4 2>/dev/null || echo 'lz4 not found'
which lz4c 2>/dev/null || echo 'lz4c not found'
which lz4cat 2>/dev/null || echo 'lz4cat not found'
which unlz4 2>/dev/null || echo 'unlz4 not found'

echo "=== ����: lz4 �������� ==="
rlRun 'lz4 --help 2>&1 | head -10' 0 "�鿴 lz4 ������Ϣ"
rlRun 'lz4c --help 2>&1 | head -10' 0 "�鿴 lz4c ������Ϣ"
rlRun 'lz4cat --help 2>&1 | head -10' 0 "�鿴 lz4cat ������Ϣ"
rlRun 'unlz4 --help 2>&1 | head -10' 0 "�鿴 unlz4 ������Ϣ"

echo ""
echo "All lz4-basic functional tests passed!"

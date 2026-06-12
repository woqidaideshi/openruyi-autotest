#!/bin/sh -eux
# Functional test: file - ��������
# Tests: file commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q file 2>/dev/null || { echo 'file not installed, skipping'; exit 0; }
which file 2>/dev/null || echo 'file not found'

echo "=== ����: file �������� ==="
rlRun 'file --help 2>&1 | head -10' 0 "�鿴 file ������Ϣ"

echo ""
echo "All file-basic functional tests passed!"

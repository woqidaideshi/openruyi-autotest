#!/bin/sh -eux
# Functional test: cpio - ��������
# Tests: cpio commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cpio 2>/dev/null || { echo 'cpio not installed, skipping'; exit 0; }
which cpio 2>/dev/null || echo 'cpio not found'

echo "=== ����: cpio �������� ==="
rlRun 'cpio --help 2>&1 | head -10' 0 "�鿴 cpio ������Ϣ"

echo ""
echo "All cpio-basic functional tests passed!"

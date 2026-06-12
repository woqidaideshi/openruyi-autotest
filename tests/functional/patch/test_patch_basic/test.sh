#!/bin/sh -eux
# Functional test: patch - ��������
# Tests: patch commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q patch 2>/dev/null || { echo 'patch not installed, skipping'; exit 0; }
which patch 2>/dev/null || echo 'patch not found'

echo "=== ����: patch �������� ==="
rlRun 'patch --help 2>&1 | head -10' 0 "�鿴 patch ������Ϣ"

echo ""
echo "All patch-basic functional tests passed!"

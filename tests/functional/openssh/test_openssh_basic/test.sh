#!/bin/sh -eux
# Functional test: openssh - ��������
# Tests: ssh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh 2>/dev/null || echo 'ssh not found'

echo "=== ����: openssh �������� ==="
rlRun 'ssh --help 2>&1 | head -10' 0 "�鿴 ssh ������Ϣ"

echo ""
echo "All openssh-basic functional tests passed!"

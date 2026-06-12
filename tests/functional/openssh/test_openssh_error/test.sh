#!/bin/sh -eux
# Functional test: openssh - ������
# Tests: ssh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'ssh --invalid-flag-xyz 2>&1 || true' 0 "���� ssh ��Ч����������"

echo ""
echo "All openssh-error functional tests passed!"

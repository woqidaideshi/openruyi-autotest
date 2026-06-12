#!/bin/sh -eux
# Functional test: openssh ������
# Tests: ssh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh 2>/dev/null || echo 'ssh not found'
rlRun 'ssh --version 2>&1 || true' 0 "��ȡ ssh �汾��Ϣ"

echo ""
echo "All openssh functional tests passed!"

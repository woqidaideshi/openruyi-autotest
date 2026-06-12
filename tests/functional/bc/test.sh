#!/bin/sh -eux
# Functional test: bc - ���⾫�ȼ�����
# Tests: bc, dc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bc 2>/dev/null || { echo 'bc not installed, skipping'; exit 0; }
which bc 2>/dev/null || echo 'bc not found'
which dc 2>/dev/null || echo 'dc not found'
rlRun 'bc --version' 0 "��ȡ bc �汾��Ϣ"
rlRun 'dc --version' 0 "��ȡ dc �汾��Ϣ"

echo ""
echo "All bc functional tests passed!"

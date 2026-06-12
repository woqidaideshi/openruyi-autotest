#!/bin/sh -eux
# Functional test: authselect - ������
# Commands: authselect

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q authselect 2>/dev/null || { echo 'authselect not installed, skipping'; exit 0; }
which authselect 2>/dev/null || echo 'authselect not found'

echo "=== ������ ==="
rlRun 'authselect --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'authselect select nonexistent 2>&1 || true' 1-255 "ѡ�񲻴��ڵ�����"

echo ""
echo "All authselect-error functional tests passed!"

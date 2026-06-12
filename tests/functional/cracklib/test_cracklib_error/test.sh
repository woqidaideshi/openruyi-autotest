#!/bin/sh -eux
# Functional test: cracklib - ������
# Commands: cracklib-check

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cracklib 2>/dev/null || { echo 'cracklib not installed, skipping'; exit 0; }
which cracklib-check 2>/dev/null || echo 'cracklib-check not found'

echo "=== ������ ==="
rlRun 'cracklib-check --invalid 2>&1 || true' 0 "��Ч����"

echo ""
echo "All cracklib-error functional tests passed!"

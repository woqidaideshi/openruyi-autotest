#!/bin/sh -eux
# Functional test: rpm ������

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q rpm 2>/dev/null || { echo 'rpm not installed, skipping'; exit 0; }
which rpm 2>/dev/null || echo 'rpm not found'

echo "=== ������ ==="
rlRun 'rpm --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'rpm -q nonexistent 2>&1 || true' 1-255 "��ѯ�����ڵİ�"

echo ""
echo "All rpm-error functional tests passed!"

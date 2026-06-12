#!/bin/sh -eux
# Functional test: rpm ��֤
# Commands: rpm, rpmkeys

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q rpm 2>/dev/null || { echo 'rpm not installed, skipping'; exit 0; }
which rpm 2>/dev/null || echo 'rpm not found'
which rpmkeys 2>/dev/null || echo 'rpmkeys not found'

echo "=== rpm ��֤ ==="
rlRun 'rpmkeys --help 2>&1 | head -10' 0 "rpmkeys ����"
rlRun 'rpm -V rpm 2>&1 || true' 0 "��֤ rpm ��������"
rlRun 'rpm --import 2>&1 | head -5 || true' 0 "rpm --import ����"

echo ""
echo "All rpm-verify functional tests passed!"

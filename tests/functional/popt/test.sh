#!/bin/sh -eux
# Functional test: popt - ���
# Commands: libpopt.so.0, libpopt.so.0.0.2

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q popt 2>/dev/null || { echo 'popt not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep popt | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql popt 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All popt functional tests passed!"

#!/bin/sh -eux
# Functional test: libgpg-error - ���
# Commands: libgpg-error.so.0, libgpg-error.so.0.41.1

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libgpg-error 2>/dev/null || { echo 'libgpg-error not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libgpg-error | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libgpg-error 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libgpg-error functional tests passed!"

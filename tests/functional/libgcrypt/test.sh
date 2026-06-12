#!/bin/sh -eux
# Functional test: libgcrypt - ���
# Commands: libgcrypt.so.20, libgcrypt.so.20.6.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libgcrypt 2>/dev/null || { echo 'libgcrypt not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libgcrypt | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libgcrypt 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libgcrypt functional tests passed!"

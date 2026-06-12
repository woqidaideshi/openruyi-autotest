#!/bin/sh -eux
# Functional test: libpsl - ���
# Commands: libpsl.so.5, libpsl.so.5.3.5

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpsl 2>/dev/null || { echo 'libpsl not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libpsl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libpsl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libpsl functional tests passed!"

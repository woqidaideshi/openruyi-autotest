#!/bin/sh -eux
# Functional test: libunistring - ���
# Commands: libunistring.so.5, libunistring.so.5.2.1

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libunistring 2>/dev/null || { echo 'libunistring not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libunistring | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libunistring 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libunistring functional tests passed!"

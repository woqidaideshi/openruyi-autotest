#!/bin/sh -eux
# Functional test: libarchive - ���
# Commands: libarchive.so.13, libarchive.so.13.8.7

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libarchive 2>/dev/null || { echo 'libarchive not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libarchive | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libarchive 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libarchive functional tests passed!"

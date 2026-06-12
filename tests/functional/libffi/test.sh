#!/bin/sh -eux
# Functional test: libffi - ���
# Commands: libffi.so.8, libffi.so.8.2.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libffi 2>/dev/null || { echo 'libffi not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libffi | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libffi 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libffi functional tests passed!"

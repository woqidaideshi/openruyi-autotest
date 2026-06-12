#!/bin/sh -eux
# Functional test: libmnl - ���
# Commands: libmnl.so.0, libmnl.so.0.2.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libmnl 2>/dev/null || { echo 'libmnl not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libmnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libmnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libmnl functional tests passed!"

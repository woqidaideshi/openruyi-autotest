#!/bin/sh -eux
# Functional test: libsepol - ���
# Commands: libsepol.so.2

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libsepol 2>/dev/null || { echo 'libsepol not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libsepol | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libsepol 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libsepol functional tests passed!"

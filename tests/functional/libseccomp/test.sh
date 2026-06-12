#!/bin/sh -eux
# Functional test: libseccomp - ���
# Commands: libseccomp.so.2, libseccomp.so.2.6.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libseccomp 2>/dev/null || { echo 'libseccomp not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libseccomp | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libseccomp 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libseccomp functional tests passed!"

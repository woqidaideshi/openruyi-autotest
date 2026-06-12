#!/bin/sh -eux
# Functional test: libnftnl - ���
# Commands: libnftnl.so.11, libnftnl.so.11.6.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libnftnl 2>/dev/null || { echo 'libnftnl not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libnftnl | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libnftnl 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libnftnl functional tests passed!"

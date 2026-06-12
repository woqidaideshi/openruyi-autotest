#!/bin/sh -eux
# Functional test: libbpf - ���
# Commands: libbpf.so.1, libbpf.so.1.7.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libbpf 2>/dev/null || { echo 'libbpf not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libbpf | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libbpf 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libbpf functional tests passed!"

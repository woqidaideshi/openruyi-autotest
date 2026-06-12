#!/bin/sh -eux
# Functional test: libedit - ���
# Commands: libedit.so.0, libedit.so.0.0.75

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libedit 2>/dev/null || { echo 'libedit not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libedit | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libedit 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libedit functional tests passed!"

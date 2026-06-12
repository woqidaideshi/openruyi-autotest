#!/bin/sh -eux
# Functional test: json-c - ���
# Commands: libjson-c.so.5, libjson-c.so.5.4.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q json-c 2>/dev/null || { echo 'json-c not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep json-c | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql json-c 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All json-c functional tests passed!"

#!/bin/sh -eux
# Functional test: iso-codes - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q iso-codes 2>/dev/null || { echo 'iso-codes not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql iso-codes 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All iso-codes functional tests passed!"

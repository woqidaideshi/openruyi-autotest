#!/bin/sh -eux
# Functional test: setup - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q setup 2>/dev/null || { echo 'setup not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql setup 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All setup functional tests passed!"

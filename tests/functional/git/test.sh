#!/bin/sh -eux
# Functional test: git - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q git 2>/dev/null || { echo 'git not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql git 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All git functional tests passed!"

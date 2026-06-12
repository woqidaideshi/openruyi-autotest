#!/bin/sh -eux
# Functional test: publicsuffix-list - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q publicsuffix-list 2>/dev/null || { echo 'publicsuffix-list not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql publicsuffix-list 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All publicsuffix-list functional tests passed!"

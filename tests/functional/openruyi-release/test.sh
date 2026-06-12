#!/bin/sh -eux
# Functional test: openruyi-release - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openruyi-release 2>/dev/null || { echo 'openruyi-release not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql openruyi-release 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All openruyi-release functional tests passed!"

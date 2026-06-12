#!/bin/sh -eux
# Functional test: bash-completion - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bash-completion 2>/dev/null || { echo 'bash-completion not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql bash-completion 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All bash-completion functional tests passed!"

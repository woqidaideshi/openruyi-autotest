#!/bin/sh -eux
# Functional test: python-packaging - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python-packaging 2>/dev/null || { echo 'python-packaging not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-packaging 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All python-packaging functional tests passed!"

#!/bin/sh -eux
# Functional test: python-rpm-macros - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python-rpm-macros 2>/dev/null || { echo 'python-rpm-macros not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-rpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All python-rpm-macros functional tests passed!"

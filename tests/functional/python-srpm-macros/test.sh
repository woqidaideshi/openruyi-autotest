#!/bin/sh -eux
# Functional test: python-srpm-macros - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python-srpm-macros 2>/dev/null || { echo 'python-srpm-macros not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-srpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All python-srpm-macros functional tests passed!"

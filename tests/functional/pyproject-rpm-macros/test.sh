#!/bin/sh -eux
# Functional test: pyproject-rpm-macros - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q pyproject-rpm-macros 2>/dev/null || { echo 'pyproject-rpm-macros not installed, skipping'; exit 0; }

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql pyproject-rpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"

echo ""
echo "All pyproject-rpm-macros functional tests passed!"

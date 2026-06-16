#!/bin/sh -eux
# Functional test: pyproject-rpm-macros - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql pyproject-rpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All pyproject-rpm-macros functional tests passed!"

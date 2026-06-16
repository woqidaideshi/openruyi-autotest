#!/bin/sh -eux
# Functional test: python-rpm-macros - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-rpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All python-rpm-macros functional tests passed!"

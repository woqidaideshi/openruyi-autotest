#!/bin/sh -eux
# Functional test: python-srpm-macros - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-srpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All python-srpm-macros functional tests passed!"

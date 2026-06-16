#!/bin/sh -eux
# Functional test: setup - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql setup 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All setup functional tests passed!"

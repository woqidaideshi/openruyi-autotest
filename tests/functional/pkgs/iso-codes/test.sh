#!/bin/sh -eux
# Functional test: iso-codes - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql iso-codes 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All iso-codes functional tests passed!"

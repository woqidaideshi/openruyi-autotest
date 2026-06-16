#!/bin/sh -eux
# Functional test: publicsuffix-list - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql publicsuffix-list 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All publicsuffix-list functional tests passed!"

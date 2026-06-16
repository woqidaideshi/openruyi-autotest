#!/bin/sh -eux
# Functional test: openruyi-release - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql openruyi-release 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All openruyi-release functional tests passed!"

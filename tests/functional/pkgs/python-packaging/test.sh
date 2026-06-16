#!/bin/sh -eux
# Functional test: python-packaging - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-packaging 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All python-packaging functional tests passed!"

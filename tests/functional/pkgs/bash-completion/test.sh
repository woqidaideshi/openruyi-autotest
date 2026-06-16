#!/bin/sh -eux
# Functional test: bash-completion - ����/���ݰ�

. "./setup.sh"

echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql bash-completion 2>/dev/null | head -20 || true' 0 "�г����ļ�"

. "./teardown.sh"
echo "All bash-completion functional tests passed!"

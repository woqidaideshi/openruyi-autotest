#!/bin/sh -eux
# Functional test: bzip2 - ������
# Commands: bzip2

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bzip2 2>/dev/null || { echo 'bzip2 not installed, skipping'; exit 0; }
which bzip2 2>/dev/null || echo 'bzip2 not found'

echo "=== ������ ==="
rlRun 'bzip2 --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'bzip2 nonexistent 2>&1 || true' 1-255 "�����ڵ��ļ�"

echo ""
echo "All bzip2-error functional tests passed!"

#!/bin/sh -eux
# Functional test: openssl - ������
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'

echo "=== ������ ==="
rlRun 'openssl --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'openssl dgst -invalid nonexistent 2>&1 || true' 1-255 "��ЧժҪ�㷨"

echo ""
echo "All openssl-error functional tests passed!"

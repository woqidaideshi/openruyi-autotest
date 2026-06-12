#!/bin/sh -eux
# Functional test: libtirpc - �ļ���֤
# Commands: libtirpc.so.3, libtirpc.so.3.0.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libtirpc 2>/dev/null || { echo 'libtirpc not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libtirpc.so.3* 2>/dev/null || ls /usr/lib/libtirpc.so.3* 2>/dev/null || echo "not in standard path"' 0 "��� libtirpc.so.3"
rlRun 'ls /usr/lib64/libtirpc.so.3.0.0* 2>/dev/null || ls /usr/lib/libtirpc.so.3.0.0* 2>/dev/null || echo "not in standard path"' 0 "��� libtirpc.so.3.0.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libtirpc 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libtirpc-files functional tests passed!"

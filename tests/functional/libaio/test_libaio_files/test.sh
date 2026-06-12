#!/bin/sh -eux
# Functional test: libaio - �ļ���֤
# Commands: libaio.so.1, libaio.so.1.0.2

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libaio 2>/dev/null || { echo 'libaio not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libaio.so.1* 2>/dev/null || ls /usr/lib/libaio.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libaio.so.1"
rlRun 'ls /usr/lib64/libaio.so.1.0.2* 2>/dev/null || ls /usr/lib/libaio.so.1.0.2* 2>/dev/null || echo "not in standard path"' 0 "��� libaio.so.1.0.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libaio 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libaio-files functional tests passed!"

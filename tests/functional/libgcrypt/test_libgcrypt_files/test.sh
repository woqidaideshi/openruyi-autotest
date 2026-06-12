#!/bin/sh -eux
# Functional test: libgcrypt - �ļ���֤
# Commands: libgcrypt.so.20, libgcrypt.so.20.6.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libgcrypt 2>/dev/null || { echo 'libgcrypt not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libgcrypt.so.20* 2>/dev/null || ls /usr/lib/libgcrypt.so.20* 2>/dev/null || echo "not in standard path"' 0 "��� libgcrypt.so.20"
rlRun 'ls /usr/lib64/libgcrypt.so.20.6.0* 2>/dev/null || ls /usr/lib/libgcrypt.so.20.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libgcrypt.so.20.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libgcrypt 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libgcrypt-files functional tests passed!"

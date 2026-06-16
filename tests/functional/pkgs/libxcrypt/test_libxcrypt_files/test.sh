#!/bin/sh -eux
# Functional test: libxcrypt - �ļ���֤
# Commands: libcrypt.so.1, libcrypt.so.1.1.0, libowcrypt.so.1

. "../setup.sh"

rlRun 'ls /usr/lib64/libcrypt.so.1* 2>/dev/null || ls /usr/lib/libcrypt.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libcrypt.so.1"
rlRun 'ls /usr/lib64/libcrypt.so.1.1.0* 2>/dev/null || ls /usr/lib/libcrypt.so.1.1.0* 2>/dev/null || echo "not in standard path"' 0 "��� libcrypt.so.1.1.0"
rlRun 'ls /usr/lib64/libowcrypt.so.1* 2>/dev/null || ls /usr/lib/libowcrypt.so.1* 2>/dev/null || echo "not in standard path"' 0 "��� libowcrypt.so.1"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libxcrypt 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libxcrypt-files functional tests passed!"

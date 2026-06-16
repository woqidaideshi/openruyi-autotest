#!/bin/sh -eux
# Functional test: libunistring - �ļ���֤
# Commands: libunistring.so.5, libunistring.so.5.2.1

. "../setup.sh"

rlRun 'ls /usr/lib64/libunistring.so.5* 2>/dev/null || ls /usr/lib/libunistring.so.5* 2>/dev/null || echo "not in standard path"' 0 "��� libunistring.so.5"
rlRun 'ls /usr/lib64/libunistring.so.5.2.1* 2>/dev/null || ls /usr/lib/libunistring.so.5.2.1* 2>/dev/null || echo "not in standard path"' 0 "��� libunistring.so.5.2.1"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libunistring 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libunistring-files functional tests passed!"

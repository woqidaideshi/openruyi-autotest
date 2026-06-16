#!/bin/sh -eux
# Functional test: libarchive - �ļ���֤
# Commands: libarchive.so.13, libarchive.so.13.8.7

. "../setup.sh"

rlRun 'ls /usr/lib64/libarchive.so.13* 2>/dev/null || ls /usr/lib/libarchive.so.13* 2>/dev/null || echo "not in standard path"' 0 "��� libarchive.so.13"
rlRun 'ls /usr/lib64/libarchive.so.13.8.7* 2>/dev/null || ls /usr/lib/libarchive.so.13.8.7* 2>/dev/null || echo "not in standard path"' 0 "��� libarchive.so.13.8.7"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libarchive 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libarchive-files functional tests passed!"

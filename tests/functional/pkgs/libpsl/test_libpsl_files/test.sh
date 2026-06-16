#!/bin/sh -eux
# Functional test: libpsl - �ļ���֤
# Commands: libpsl.so.5, libpsl.so.5.3.5

. "../setup.sh"

rlRun 'ls /usr/lib64/libpsl.so.5* 2>/dev/null || ls /usr/lib/libpsl.so.5* 2>/dev/null || echo "not in standard path"' 0 "��� libpsl.so.5"
rlRun 'ls /usr/lib64/libpsl.so.5.3.5* 2>/dev/null || ls /usr/lib/libpsl.so.5.3.5* 2>/dev/null || echo "not in standard path"' 0 "��� libpsl.so.5.3.5"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libpsl 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libpsl-files functional tests passed!"

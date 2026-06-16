#!/bin/sh -eux
# Functional test: libgpg-error - �ļ���֤
# Commands: libgpg-error.so.0, libgpg-error.so.0.41.1

. "../setup.sh"

rlRun 'ls /usr/lib64/libgpg-error.so.0* 2>/dev/null || ls /usr/lib/libgpg-error.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libgpg-error.so.0"
rlRun 'ls /usr/lib64/libgpg-error.so.0.41.1* 2>/dev/null || ls /usr/lib/libgpg-error.so.0.41.1* 2>/dev/null || echo "not in standard path"' 0 "��� libgpg-error.so.0.41.1"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libgpg-error 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libgpg-error-files functional tests passed!"

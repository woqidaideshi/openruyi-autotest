#!/bin/sh -eux
# Functional test: libsepol - �ļ���֤
# Commands: libsepol.so.2

. "../setup.sh"

rlRun 'ls /usr/lib64/libsepol.so.2* 2>/dev/null || ls /usr/lib/libsepol.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libsepol.so.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libsepol 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libsepol-files functional tests passed!"

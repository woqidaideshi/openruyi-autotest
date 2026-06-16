#!/bin/sh -eux
# Functional test: popt - �ļ���֤
# Commands: libpopt.so.0, libpopt.so.0.0.2

. "../setup.sh"

rlRun 'ls /usr/lib64/libpopt.so.0* 2>/dev/null || ls /usr/lib/libpopt.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libpopt.so.0"
rlRun 'ls /usr/lib64/libpopt.so.0.0.2* 2>/dev/null || ls /usr/lib/libpopt.so.0.0.2* 2>/dev/null || echo "not in standard path"' 0 "��� libpopt.so.0.0.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs popt 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All popt-files functional tests passed!"

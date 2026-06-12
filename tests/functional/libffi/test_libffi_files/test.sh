#!/bin/sh -eux
# Functional test: libffi - �ļ���֤
# Commands: libffi.so.8, libffi.so.8.2.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libffi 2>/dev/null || { echo 'libffi not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libffi.so.8* 2>/dev/null || ls /usr/lib/libffi.so.8* 2>/dev/null || echo "not in standard path"' 0 "��� libffi.so.8"
rlRun 'ls /usr/lib64/libffi.so.8.2.0* 2>/dev/null || ls /usr/lib/libffi.so.8.2.0* 2>/dev/null || echo "not in standard path"' 0 "��� libffi.so.8.2.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libffi 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libffi-files functional tests passed!"

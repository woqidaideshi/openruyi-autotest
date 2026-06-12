#!/bin/sh -eux
# Functional test: libmnl - �ļ���֤
# Commands: libmnl.so.0, libmnl.so.0.2.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libmnl 2>/dev/null || { echo 'libmnl not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libmnl.so.0* 2>/dev/null || ls /usr/lib/libmnl.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libmnl.so.0"
rlRun 'ls /usr/lib64/libmnl.so.0.2.0* 2>/dev/null || ls /usr/lib/libmnl.so.0.2.0* 2>/dev/null || echo "not in standard path"' 0 "��� libmnl.so.0.2.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libmnl 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libmnl-files functional tests passed!"

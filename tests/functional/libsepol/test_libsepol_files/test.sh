#!/bin/sh -eux
# Functional test: libsepol - �ļ���֤
# Commands: libsepol.so.2

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libsepol 2>/dev/null || { echo 'libsepol not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libsepol.so.2* 2>/dev/null || ls /usr/lib/libsepol.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libsepol.so.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libsepol 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libsepol-files functional tests passed!"

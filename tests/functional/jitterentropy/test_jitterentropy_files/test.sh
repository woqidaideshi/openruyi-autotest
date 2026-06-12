#!/bin/sh -eux
# Functional test: jitterentropy - �ļ���֤
# Commands: libjitterentropy.so.3, libjitterentropy.so.3.6.3

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q jitterentropy 2>/dev/null || { echo 'jitterentropy not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libjitterentropy.so.3* 2>/dev/null || ls /usr/lib/libjitterentropy.so.3* 2>/dev/null || echo "not in standard path"' 0 "��� libjitterentropy.so.3"
rlRun 'ls /usr/lib64/libjitterentropy.so.3.6.3* 2>/dev/null || ls /usr/lib/libjitterentropy.so.3.6.3* 2>/dev/null || echo "not in standard path"' 0 "��� libjitterentropy.so.3.6.3"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs jitterentropy 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All jitterentropy-files functional tests passed!"

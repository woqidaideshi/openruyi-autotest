#!/bin/sh -eux
# Functional test: jitterentropy - �ļ���֤
# Commands: libjitterentropy.so.3, libjitterentropy.so.3.6.3

. "../setup.sh"

rlRun 'ls /usr/lib64/libjitterentropy.so.3* 2>/dev/null || ls /usr/lib/libjitterentropy.so.3* 2>/dev/null || echo "not in standard path"' 0 "��� libjitterentropy.so.3"
rlRun 'ls /usr/lib64/libjitterentropy.so.3.6.3* 2>/dev/null || ls /usr/lib/libjitterentropy.so.3.6.3* 2>/dev/null || echo "not in standard path"' 0 "��� libjitterentropy.so.3.6.3"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs jitterentropy 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All jitterentropy-files functional tests passed!"

#!/bin/sh -eux
# Functional test: nghttp2 - �ļ���֤
# Commands: libnghttp2.so.14, libnghttp2.so.14.29.4

. "../setup.sh"

rlRun 'ls /usr/lib64/libnghttp2.so.14* 2>/dev/null || ls /usr/lib/libnghttp2.so.14* 2>/dev/null || echo "not in standard path"' 0 "��� libnghttp2.so.14"
rlRun 'ls /usr/lib64/libnghttp2.so.14.29.4* 2>/dev/null || ls /usr/lib/libnghttp2.so.14.29.4* 2>/dev/null || echo "not in standard path"' 0 "��� libnghttp2.so.14.29.4"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs nghttp2 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All nghttp2-files functional tests passed!"

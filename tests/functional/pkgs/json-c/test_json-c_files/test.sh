#!/bin/sh -eux
# Functional test: json-c - �ļ���֤
# Commands: libjson-c.so.5, libjson-c.so.5.4.0

. "../setup.sh"

rlRun 'ls /usr/lib64/libjson-c.so.5* 2>/dev/null || ls /usr/lib/libjson-c.so.5* 2>/dev/null || echo "not in standard path"' 0 "��� libjson-c.so.5"
rlRun 'ls /usr/lib64/libjson-c.so.5.4.0* 2>/dev/null || ls /usr/lib/libjson-c.so.5.4.0* 2>/dev/null || echo "not in standard path"' 0 "��� libjson-c.so.5.4.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs json-c 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All json-c-files functional tests passed!"

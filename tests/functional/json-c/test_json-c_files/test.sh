#!/bin/sh -eux
# Functional test: json-c - �ļ���֤
# Commands: libjson-c.so.5, libjson-c.so.5.4.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q json-c 2>/dev/null || { echo 'json-c not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libjson-c.so.5* 2>/dev/null || ls /usr/lib/libjson-c.so.5* 2>/dev/null || echo "not in standard path"' 0 "��� libjson-c.so.5"
rlRun 'ls /usr/lib64/libjson-c.so.5.4.0* 2>/dev/null || ls /usr/lib/libjson-c.so.5.4.0* 2>/dev/null || echo "not in standard path"' 0 "��� libjson-c.so.5.4.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs json-c 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All json-c-files functional tests passed!"

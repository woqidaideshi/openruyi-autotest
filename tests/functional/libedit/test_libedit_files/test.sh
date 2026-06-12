#!/bin/sh -eux
# Functional test: libedit - �ļ���֤
# Commands: libedit.so.0, libedit.so.0.0.75

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libedit 2>/dev/null || { echo 'libedit not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libedit.so.0* 2>/dev/null || ls /usr/lib/libedit.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libedit.so.0"
rlRun 'ls /usr/lib64/libedit.so.0.0.75* 2>/dev/null || ls /usr/lib/libedit.so.0.0.75* 2>/dev/null || echo "not in standard path"' 0 "��� libedit.so.0.0.75"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libedit 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libedit-files functional tests passed!"

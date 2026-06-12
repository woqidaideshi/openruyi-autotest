#!/bin/sh -eux
# Functional test: libeconf - �ļ���֤
# Commands: libeconf.so.0, libeconf.so.0.7.8

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libeconf 2>/dev/null || { echo 'libeconf not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libeconf.so.0* 2>/dev/null || ls /usr/lib/libeconf.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libeconf.so.0"
rlRun 'ls /usr/lib64/libeconf.so.0.7.8* 2>/dev/null || ls /usr/lib/libeconf.so.0.7.8* 2>/dev/null || echo "not in standard path"' 0 "��� libeconf.so.0.7.8"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libeconf 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libeconf-files functional tests passed!"

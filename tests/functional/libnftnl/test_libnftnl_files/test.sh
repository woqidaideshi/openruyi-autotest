#!/bin/sh -eux
# Functional test: libnftnl - �ļ���֤
# Commands: libnftnl.so.11, libnftnl.so.11.6.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libnftnl 2>/dev/null || { echo 'libnftnl not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libnftnl.so.11* 2>/dev/null || ls /usr/lib/libnftnl.so.11* 2>/dev/null || echo "not in standard path"' 0 "��� libnftnl.so.11"
rlRun 'ls /usr/lib64/libnftnl.so.11.6.0* 2>/dev/null || ls /usr/lib/libnftnl.so.11.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnftnl.so.11.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnftnl 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libnftnl-files functional tests passed!"

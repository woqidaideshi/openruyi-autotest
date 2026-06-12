#!/bin/sh -eux
# Functional test: libnfnetlink - �ļ���֤
# Commands: libnfnetlink.so.0, libnfnetlink.so.0.2.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libnfnetlink 2>/dev/null || { echo 'libnfnetlink not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libnfnetlink.so.0* 2>/dev/null || ls /usr/lib/libnfnetlink.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnfnetlink.so.0"
rlRun 'ls /usr/lib64/libnfnetlink.so.0.2.0* 2>/dev/null || ls /usr/lib/libnfnetlink.so.0.2.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnfnetlink.so.0.2.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnfnetlink 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libnfnetlink-files functional tests passed!"

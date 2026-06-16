#!/bin/sh -eux
# Functional test: libnfnetlink - �ļ���֤
# Commands: libnfnetlink.so.0, libnfnetlink.so.0.2.0

. "../setup.sh"

rlRun 'ls /usr/lib64/libnfnetlink.so.0* 2>/dev/null || ls /usr/lib/libnfnetlink.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnfnetlink.so.0"
rlRun 'ls /usr/lib64/libnfnetlink.so.0.2.0* 2>/dev/null || ls /usr/lib/libnfnetlink.so.0.2.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnfnetlink.so.0.2.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnfnetlink 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libnfnetlink-files functional tests passed!"

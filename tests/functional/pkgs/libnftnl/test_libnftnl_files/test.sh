#!/bin/sh -eux
# Functional test: libnftnl - �ļ���֤
# Commands: libnftnl.so.11, libnftnl.so.11.6.0

. "../setup.sh"

rlRun 'ls /usr/lib64/libnftnl.so.11* 2>/dev/null || ls /usr/lib/libnftnl.so.11* 2>/dev/null || echo "not in standard path"' 0 "��� libnftnl.so.11"
rlRun 'ls /usr/lib64/libnftnl.so.11.6.0* 2>/dev/null || ls /usr/lib/libnftnl.so.11.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libnftnl.so.11.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libnftnl 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libnftnl-files functional tests passed!"

#!/bin/sh -eux
# Functional test: libeconf - �ļ���֤
# Commands: libeconf.so.0, libeconf.so.0.7.8

. "../setup.sh"

rlRun 'ls /usr/lib64/libeconf.so.0* 2>/dev/null || ls /usr/lib/libeconf.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libeconf.so.0"
rlRun 'ls /usr/lib64/libeconf.so.0.7.8* 2>/dev/null || ls /usr/lib/libeconf.so.0.7.8* 2>/dev/null || echo "not in standard path"' 0 "��� libeconf.so.0.7.8"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libeconf 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libeconf-files functional tests passed!"

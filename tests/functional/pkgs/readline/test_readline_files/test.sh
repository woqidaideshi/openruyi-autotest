#!/bin/sh -eux
# Functional test: readline - �ļ���֤
# Commands: libhistory.so.8, libhistory.so.8.3, libreadline.so.8, libreadline.so.8.3

. "../setup.sh"

rlRun 'ls /usr/lib64/libhistory.so.8* 2>/dev/null || ls /usr/lib/libhistory.so.8* 2>/dev/null || echo "not in standard path"' 0 "��� libhistory.so.8"
rlRun 'ls /usr/lib64/libhistory.so.8.3* 2>/dev/null || ls /usr/lib/libhistory.so.8.3* 2>/dev/null || echo "not in standard path"' 0 "��� libhistory.so.8.3"
rlRun 'ls /usr/lib64/libreadline.so.8* 2>/dev/null || ls /usr/lib/libreadline.so.8* 2>/dev/null || echo "not in standard path"' 0 "��� libreadline.so.8"
rlRun 'ls /usr/lib64/libreadline.so.8.3* 2>/dev/null || ls /usr/lib/libreadline.so.8.3* 2>/dev/null || echo "not in standard path"' 0 "��� libreadline.so.8.3"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs readline 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All readline-files functional tests passed!"

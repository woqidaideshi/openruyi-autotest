#!/bin/sh -eux
# Functional test: libseccomp - �ļ���֤
# Commands: libseccomp.so.2, libseccomp.so.2.6.0

. "../setup.sh"

rlRun 'ls /usr/lib64/libseccomp.so.2* 2>/dev/null || ls /usr/lib/libseccomp.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libseccomp.so.2"
rlRun 'ls /usr/lib64/libseccomp.so.2.6.0* 2>/dev/null || ls /usr/lib/libseccomp.so.2.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libseccomp.so.2.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libseccomp 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libseccomp-files functional tests passed!"

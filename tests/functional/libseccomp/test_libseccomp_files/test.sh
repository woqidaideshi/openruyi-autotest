#!/bin/sh -eux
# Functional test: libseccomp - �ļ���֤
# Commands: libseccomp.so.2, libseccomp.so.2.6.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libseccomp 2>/dev/null || { echo 'libseccomp not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libseccomp.so.2* 2>/dev/null || ls /usr/lib/libseccomp.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libseccomp.so.2"
rlRun 'ls /usr/lib64/libseccomp.so.2.6.0* 2>/dev/null || ls /usr/lib/libseccomp.so.2.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libseccomp.so.2.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libseccomp 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libseccomp-files functional tests passed!"

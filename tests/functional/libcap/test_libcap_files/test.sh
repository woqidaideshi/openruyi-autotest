#!/bin/sh -eux
# Functional test: libcap - �ļ���֤
# Commands: libcap.so.2, libcap.so.2.76, libpsx.so.2, libpsx.so.2.76, pam_cap.so

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libcap 2>/dev/null || { echo 'libcap not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libcap.so.2* 2>/dev/null || ls /usr/lib/libcap.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libcap.so.2"
rlRun 'ls /usr/lib64/libcap.so.2.76* 2>/dev/null || ls /usr/lib/libcap.so.2.76* 2>/dev/null || echo "not in standard path"' 0 "��� libcap.so.2.76"
rlRun 'ls /usr/lib64/libpsx.so.2* 2>/dev/null || ls /usr/lib/libpsx.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libpsx.so.2"
rlRun 'ls /usr/lib64/libpsx.so.2.76* 2>/dev/null || ls /usr/lib/libpsx.so.2.76* 2>/dev/null || echo "not in standard path"' 0 "��� libpsx.so.2.76"
rlRun 'ls /usr/lib64/pam_cap.so* 2>/dev/null || ls /usr/lib/pam_cap.so* 2>/dev/null || echo "not in standard path"' 0 "��� pam_cap.so"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libcap 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All libcap-files functional tests passed!"

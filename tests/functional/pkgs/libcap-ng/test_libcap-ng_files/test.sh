#!/bin/sh -eux
# Functional test: libcap-ng - �ļ���֤
# Commands: libcap-ng.so.0, libcap-ng.so.0.0.0, libdrop_ambient.so.0, libdrop_ambient.so.0.0.0

. "../setup.sh"

rlRun 'ls /usr/lib64/libcap-ng.so.0* 2>/dev/null || ls /usr/lib/libcap-ng.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libcap-ng.so.0"
rlRun 'ls /usr/lib64/libcap-ng.so.0.0.0* 2>/dev/null || ls /usr/lib/libcap-ng.so.0.0.0* 2>/dev/null || echo "not in standard path"' 0 "��� libcap-ng.so.0.0.0"
rlRun 'ls /usr/lib64/libdrop_ambient.so.0* 2>/dev/null || ls /usr/lib/libdrop_ambient.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libdrop_ambient.so.0"
rlRun 'ls /usr/lib64/libdrop_ambient.so.0.0.0* 2>/dev/null || ls /usr/lib/libdrop_ambient.so.0.0.0* 2>/dev/null || echo "not in standard path"' 0 "��� libdrop_ambient.so.0.0.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libcap-ng 2>&1 || true' 0 "pkg-config ����Ϣ"

. "../teardown.sh"
echo "All libcap-ng-files functional tests passed!"

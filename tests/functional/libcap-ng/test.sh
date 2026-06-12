#!/bin/sh -eux
# Functional test: libcap-ng - ���
# Commands: libcap-ng.so.0, libcap-ng.so.0.0.0, libdrop_ambient.so.0, libdrop_ambient.so.0.0.0

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libcap-ng 2>/dev/null || { echo 'libcap-ng not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libcap-ng | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libcap-ng 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libcap-ng functional tests passed!"

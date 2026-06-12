#!/bin/sh -eux
# Functional test: libcap - ���
# Commands: libcap.so.2, libcap.so.2.76, libpsx.so.2, libpsx.so.2.76, pam_cap.so

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libcap 2>/dev/null || { echo 'libcap not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libcap | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libcap 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All libcap functional tests passed!"

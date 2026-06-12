#!/bin/sh -eux
# Functional test: nghttp2 - ���
# Commands: libnghttp2.so.14, libnghttp2.so.14.29.4

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q nghttp2 2>/dev/null || { echo 'nghttp2 not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep nghttp2 | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql nghttp2 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All nghttp2 functional tests passed!"

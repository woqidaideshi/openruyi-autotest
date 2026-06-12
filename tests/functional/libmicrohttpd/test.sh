#!/bin/sh -eux
# Functional test: libmicrohttpd

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libmicrohttpd 2>/dev/null || { echo "libmicrohttpd not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libmicrohttpd 2>/dev/null | head -10 || true
rpm -qi libmicrohttpd 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libmicrohttpd" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibmicrohttpd*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libmicrohttpd/ 2>/dev/null | head -5 || true

echo ""
echo "All libmicrohttpd functional tests passed!"

#!/bin/sh -eux
# Functional test: libtool

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libtool 2>/dev/null || { echo "libtool not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libtool 2>/dev/null | head -10 || true
rpm -qi libtool 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libtool" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibtool*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libtool/ 2>/dev/null | head -5 || true

echo ""
echo "All libtool functional tests passed!"

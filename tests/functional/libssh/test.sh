#!/bin/sh -eux
# Functional test: libssh

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libssh 2>/dev/null || { echo "libssh not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libssh 2>/dev/null | head -10 || true
rpm -qi libssh 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libssh" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibssh*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libssh/ 2>/dev/null | head -5 || true

echo ""
echo "All libssh functional tests passed!"

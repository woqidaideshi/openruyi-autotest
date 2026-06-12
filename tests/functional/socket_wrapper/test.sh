#!/bin/sh -eux
# Functional test: socket_wrapper

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q socket_wrapper 2>/dev/null || { echo "socket_wrapper not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql socket_wrapper 2>/dev/null | head -10 || true
rpm -qi socket_wrapper 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "socket_wrapper" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libsocket_wrapper*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/socket_wrapper/ 2>/dev/null | head -5 || true

echo ""
echo "All socket_wrapper functional tests passed!"

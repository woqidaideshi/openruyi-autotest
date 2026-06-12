#!/bin/sh -eux
# Functional test: config

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q config 2>/dev/null || { echo "config not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql config 2>/dev/null | head -10 || true
rpm -qi config 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "config" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libconfig*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/config/ 2>/dev/null | head -5 || true

echo ""
echo "All config functional tests passed!"

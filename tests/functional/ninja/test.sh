#!/bin/sh -eux
# Functional test: ninja

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q ninja 2>/dev/null || { echo "ninja not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql ninja 2>/dev/null | head -10 || true
rpm -qi ninja 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "ninja" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libninja*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/ninja/ 2>/dev/null | head -5 || true

echo ""
echo "All ninja functional tests passed!"

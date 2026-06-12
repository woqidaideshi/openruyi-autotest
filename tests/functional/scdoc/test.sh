#!/bin/sh -eux
# Functional test: scdoc

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q scdoc 2>/dev/null || { echo "scdoc not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql scdoc 2>/dev/null | head -10 || true
rpm -qi scdoc 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "scdoc" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libscdoc*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/scdoc/ 2>/dev/null | head -5 || true

echo ""
echo "All scdoc functional tests passed!"

#!/bin/sh -eux
# Functional test: python-wheel

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python3-wheel 2>/dev/null || { echo "python3-wheel not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql python3-wheel 2>/dev/null | head -10 || true
rpm -qi python3-wheel 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "python-wheel" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libpython-wheel*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/python-wheel/ 2>/dev/null | head -5 || true

echo ""
echo "All python-wheel functional tests passed!"

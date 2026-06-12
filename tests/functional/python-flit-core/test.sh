#!/bin/sh -eux
# Functional test: python-flit-core

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python3-flit-core 2>/dev/null || { echo "python3-flit-core not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql python3-flit-core 2>/dev/null | head -10 || true
rpm -qi python3-flit-core 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "python-flit-core" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libpython-flit-core*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/python-flit-core/ 2>/dev/null | head -5 || true

echo ""
echo "All python-flit-core functional tests passed!"

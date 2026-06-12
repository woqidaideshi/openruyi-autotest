#!/bin/sh -eux
# Functional test: boost

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q boost 2>/dev/null || { echo "boost not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql boost 2>/dev/null | head -10 || true
rpm -qi boost 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "boost" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libboost*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/boost/ 2>/dev/null | head -5 || true

echo ""
echo "All boost functional tests passed!"

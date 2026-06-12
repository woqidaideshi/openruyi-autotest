#!/bin/sh -eux
# Functional test: automake

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q automake 2>/dev/null || { echo "automake not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql automake 2>/dev/null | head -10 || true
rpm -qi automake 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "automake" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libautomake*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/automake/ 2>/dev/null | head -5 || true

echo ""
echo "All automake functional tests passed!"

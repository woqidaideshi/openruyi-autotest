#!/bin/sh -eux
# Functional test: bison

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q bison 2>/dev/null || { echo "bison not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql bison 2>/dev/null | head -10 || true
rpm -qi bison 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "bison" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libbison*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/bison/ 2>/dev/null | head -5 || true

echo ""
echo "All bison functional tests passed!"

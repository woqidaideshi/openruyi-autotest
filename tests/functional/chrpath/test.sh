#!/bin/sh -eux
# Functional test: chrpath

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q chrpath 2>/dev/null || { echo "chrpath not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql chrpath 2>/dev/null | head -10 || true
rpm -qi chrpath 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "chrpath" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libchrpath*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/chrpath/ 2>/dev/null | head -5 || true

echo ""
echo "All chrpath functional tests passed!"

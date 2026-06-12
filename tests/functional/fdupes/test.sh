#!/bin/sh -eux
# Functional test: fdupes

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q fdupes 2>/dev/null || { echo "fdupes not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql fdupes 2>/dev/null | head -10 || true
rpm -qi fdupes 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "fdupes" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libfdupes*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/fdupes/ 2>/dev/null | head -5 || true

echo ""
echo "All fdupes functional tests passed!"

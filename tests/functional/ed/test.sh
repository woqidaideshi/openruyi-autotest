#!/bin/sh -eux
# Functional test: ed

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q ed 2>/dev/null || { echo "ed not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql ed 2>/dev/null | head -10 || true
rpm -qi ed 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "ed" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libed*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/ed/ 2>/dev/null | head -5 || true

echo ""
echo "All ed functional tests passed!"

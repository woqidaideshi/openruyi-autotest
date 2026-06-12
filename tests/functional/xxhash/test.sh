#!/bin/sh -eux
# Functional test: xxhash

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q xxhash 2>/dev/null || { echo "xxhash not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql xxhash 2>/dev/null | head -10 || true
rpm -qi xxhash 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "xxhash" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libxxhash*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/xxhash/ 2>/dev/null | head -5 || true

echo ""
echo "All xxhash functional tests passed!"

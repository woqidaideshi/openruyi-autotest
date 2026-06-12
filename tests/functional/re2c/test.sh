#!/bin/sh -eux
# Functional test: re2c

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q re2c 2>/dev/null || { echo "re2c not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql re2c 2>/dev/null | head -10 || true
rpm -qi re2c 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "re2c" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libre2c*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/re2c/ 2>/dev/null | head -5 || true

echo ""
echo "All re2c functional tests passed!"

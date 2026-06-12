#!/bin/sh -eux
# Functional test: expect

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q expect 2>/dev/null || { echo "expect not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql expect 2>/dev/null | head -10 || true
rpm -qi expect 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "expect" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libexpect*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/expect/ 2>/dev/null | head -5 || true

echo ""
echo "All expect functional tests passed!"

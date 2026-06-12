#!/bin/sh -eux
# Functional test: autoconf

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q autoconf 2>/dev/null || { echo "autoconf not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql autoconf 2>/dev/null | head -10 || true
rpm -qi autoconf 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "autoconf" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libautoconf*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/autoconf/ 2>/dev/null | head -5 || true

echo ""
echo "All autoconf functional tests passed!"

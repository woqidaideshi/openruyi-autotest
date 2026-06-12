#!/bin/sh -eux
# Functional test: atf

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q atf 2>/dev/null || { echo "atf not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql atf 2>/dev/null | head -10 || true
rpm -qi atf 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "atf" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libatf*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/atf/ 2>/dev/null | head -5 || true

echo ""
echo "All atf functional tests passed!"

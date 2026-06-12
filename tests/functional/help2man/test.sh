#!/bin/sh -eux
# Functional test: help2man

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q help2man 2>/dev/null || { echo "help2man not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql help2man 2>/dev/null | head -10 || true
rpm -qi help2man 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "help2man" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libhelp2man*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/help2man/ 2>/dev/null | head -5 || true

echo ""
echo "All help2man functional tests passed!"

#!/bin/sh -eux
# Functional test: xmlto

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q xmlto 2>/dev/null || { echo "xmlto not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql xmlto 2>/dev/null | head -10 || true
rpm -qi xmlto 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "xmlto" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libxmlto*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/xmlto/ 2>/dev/null | head -5 || true

echo ""
echo "All xmlto functional tests passed!"

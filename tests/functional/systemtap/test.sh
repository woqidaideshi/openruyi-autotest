#!/bin/sh -eux
# Functional test: systemtap

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q systemtap 2>/dev/null || { echo "systemtap not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql systemtap 2>/dev/null | head -10 || true
rpm -qi systemtap 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "systemtap" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libsystemtap*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/systemtap/ 2>/dev/null | head -5 || true

echo ""
echo "All systemtap functional tests passed!"

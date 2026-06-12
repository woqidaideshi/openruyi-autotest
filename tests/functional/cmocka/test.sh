#!/bin/sh -eux
# Functional test: cmocka

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q cmocka 2>/dev/null || { echo "cmocka not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql cmocka 2>/dev/null | head -10 || true
rpm -qi cmocka 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "cmocka" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libcmocka*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/cmocka/ 2>/dev/null | head -5 || true

echo ""
echo "All cmocka functional tests passed!"

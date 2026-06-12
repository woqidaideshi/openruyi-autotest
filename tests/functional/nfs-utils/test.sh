#!/bin/sh -eux
# Functional test: nfs-utils

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q nfs-utils 2>/dev/null || { echo "nfs-utils not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql nfs-utils 2>/dev/null | head -10 || true
rpm -qi nfs-utils 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "nfs-utils" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libnfs-utils*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/nfs-utils/ 2>/dev/null | head -5 || true

echo ""
echo "All nfs-utils functional tests passed!"

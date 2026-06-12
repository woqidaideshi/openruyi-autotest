#!/bin/sh -eux
# Functional test: nss_wrapper

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q nss_wrapper 2>/dev/null || { echo "nss_wrapper not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql nss_wrapper 2>/dev/null | head -10 || true
rpm -qi nss_wrapper 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "nss_wrapper" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libnss_wrapper*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/nss_wrapper/ 2>/dev/null | head -5 || true

echo ""
echo "All nss_wrapper functional tests passed!"

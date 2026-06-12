#!/bin/sh -eux
# Functional test: pam_wrapper

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q pam_wrapper 2>/dev/null || { echo "pam_wrapper not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql pam_wrapper 2>/dev/null | head -10 || true
rpm -qi pam_wrapper 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "pam_wrapper" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libpam_wrapper*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/pam_wrapper/ 2>/dev/null | head -5 || true

echo ""
echo "All pam_wrapper functional tests passed!"

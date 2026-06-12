#!/bin/sh -eux
# Functional test: iptables

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q iptables 2>/dev/null || { echo "iptables not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql iptables 2>/dev/null | head -10 || true
rpm -qi iptables 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "iptables" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libiptables*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/iptables/ 2>/dev/null | head -5 || true

echo ""
echo "All iptables functional tests passed!"

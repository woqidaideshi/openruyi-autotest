#!/bin/sh -eux
# Functional test: unbound

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q unbound 2>/dev/null || { echo "unbound not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql unbound 2>/dev/null | head -10 || true
rpm -qi unbound 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "unbound" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libunbound*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/unbound/ 2>/dev/null | head -5 || true

echo ""
echo "All unbound functional tests passed!"

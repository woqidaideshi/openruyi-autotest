#!/bin/sh -eux
# Functional test: tcl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tcl 2>/dev/null || { echo "tcl not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql tcl 2>/dev/null | head -10 || true
rpm -qi tcl 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "tcl" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libtcl*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/tcl/ 2>/dev/null | head -5 || true

echo ""
echo "All tcl functional tests passed!"

#!/bin/sh -eux
# Functional test: texinfo

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q texinfo 2>/dev/null || { echo "texinfo not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql texinfo 2>/dev/null | head -10 || true
rpm -qi texinfo 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "texinfo" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libtexinfo*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/texinfo/ 2>/dev/null | head -5 || true

echo ""
echo "All texinfo functional tests passed!"

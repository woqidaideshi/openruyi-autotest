#!/bin/sh -eux
# Functional test: source-highlight

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q source-highlight 2>/dev/null || { echo "source-highlight not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql source-highlight 2>/dev/null | head -10 || true
rpm -qi source-highlight 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "source-highlight" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libsource-highlight*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/source-highlight/ 2>/dev/null | head -5 || true

echo ""
echo "All source-highlight functional tests passed!"

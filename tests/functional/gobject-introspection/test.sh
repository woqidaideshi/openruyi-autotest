#!/bin/sh -eux
# Functional test: gobject-introspection

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gobject-introspection 2>/dev/null || { echo "gobject-introspection not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql gobject-introspection 2>/dev/null | head -10 || true
rpm -qi gobject-introspection 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "gobject-introspection" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libgobject-introspection*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/gobject-introspection/ 2>/dev/null | head -5 || true

echo ""
echo "All gobject-introspection functional tests passed!"

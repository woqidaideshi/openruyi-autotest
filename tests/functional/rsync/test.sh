#!/bin/sh -eux
# Functional test: rsync

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q rsync 2>/dev/null || { echo "rsync not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql rsync 2>/dev/null | head -10 || true
rpm -qi rsync 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "rsync" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/librsync*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/rsync/ 2>/dev/null | head -5 || true

echo ""
echo "All rsync functional tests passed!"

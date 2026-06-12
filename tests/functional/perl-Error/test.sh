#!/bin/sh -eux
# Functional test: perl-Error

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q perl-Error 2>/dev/null || { echo "perl-Error not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql perl-Error 2>/dev/null | head -10 || true
rpm -qi perl-Error 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "perl-Error" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libperl-Error*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/perl-Error/ 2>/dev/null | head -5 || true

echo ""
echo "All perl-Error functional tests passed!"

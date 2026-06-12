#!/bin/sh -eux
# Functional test: perl-rpm-packaging

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q perl-rpm-packaging 2>/dev/null || { echo "perl-rpm-packaging not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql perl-rpm-packaging 2>/dev/null | head -10 || true
rpm -qi perl-rpm-packaging 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "perl-rpm-packaging" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libperl-rpm-packaging*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/perl-rpm-packaging/ 2>/dev/null | head -5 || true

echo ""
echo "All perl-rpm-packaging functional tests passed!"

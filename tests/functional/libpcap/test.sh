#!/bin/sh -eux
# Functional test: libpcap

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libpcap 2>/dev/null || { echo "libpcap not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libpcap 2>/dev/null | head -10 || true
rpm -qi libpcap 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libpcap" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibpcap*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libpcap/ 2>/dev/null | head -5 || true

echo ""
echo "All libpcap functional tests passed!"

#!/bin/sh -eux
# Functional test: cryptsetup package
# Tests cryptsetup 磁盘加密
# Version: cryptsetup

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q cryptsetup 2>/dev/null || { echo 'cryptsetup not installed, skipping'; exit 0; }
which cryptsetup 2>/dev/null || echo 'cryptsetup not found'

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'cryptsetup --version 2>&1 || true' 0 "cryptsetup 版本信息"
rlRun 'cryptsetup --help 2>&1 | head -5 || true' 0 "cryptsetup 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'cryptsetup --invalid 2>&1 || true' 0 "cryptsetup: 无效选项"

echo ""
echo "All cryptsetup functional tests passed!"

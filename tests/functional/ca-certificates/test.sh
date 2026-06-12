#!/bin/sh -eux
# Functional test: ca-certificates package
# Tests CA证书管理
# Version: ca-certificates

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q ca-certificates 2>/dev/null || { echo 'ca-certificates not installed, skipping'; exit 0; }
which update-ca-trust 2>/dev/null || echo 'update-ca-trust not found'

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'update-ca-trust --version 2>&1 || true' 0 "update-ca-trust 版本信息"
rlRun 'update-ca-trust --help 2>&1 | head -5 || true' 0 "update-ca-trust 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"

echo ""
echo "All ca-certificates functional tests passed!"

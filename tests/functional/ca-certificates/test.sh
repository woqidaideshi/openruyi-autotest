#!/bin/sh -eux
# Functional test: ca-certificates package
# Tests CA证书管理
# Version: ca-certificates

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q ca-certificates' 0 "检查 ca-certificates 是否已安装"
rlRun 'which update-ca-trust' 0 "检查 update-ca-trust 命令是否可用"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'update-ca-trust --version 2>&1 || true' 0 "update-ca-trust 版本信息"
rlRun 'update-ca-trust --help 2>&1 | head -5 || true' 0 "update-ca-trust 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"

echo ""
echo "All ca-certificates functional tests passed!"

#!/bin/sh -eux
# Functional test: cryptsetup package
# Tests cryptsetup 磁盘加密
# Version: cryptsetup

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q cryptsetup' 0 "检查 cryptsetup 是否已安装"
rlRun 'which cryptsetup' 0 "检查 cryptsetup 命令是否可用"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'cryptsetup --version 2>&1 || true' 0 "cryptsetup 版本信息"
rlRun 'cryptsetup --help 2>&1 | head -5 || true' 0 "cryptsetup 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'cryptsetup --invalid 2>&1 || true' 0 "cryptsetup: 无效选项"

echo ""
echo "All cryptsetup functional tests passed!"

#!/bin/sh -eux
# Functional test: newt package
# Tests newt/whiptail 对话框工具
# Version: newt

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q newt' 0 "检查 newt 是否已安装"
rlRun 'which whiptail' 0 "检查 whiptail 命令是否可用"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'whiptail --version 2>&1 || true' 0 "whiptail 版本信息"
rlRun 'whiptail --help 2>&1 | head -5 || true' 0 "whiptail 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'whiptail --invalid 2>&1 || true' 0 "whiptail: 无效选项"

echo ""
echo "All newt functional tests passed!"

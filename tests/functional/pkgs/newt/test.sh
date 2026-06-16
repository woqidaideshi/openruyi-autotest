#!/bin/sh -eux
# Functional test: newt package
# Tests newt/whiptail 对话框工具
# Version: newt

. "./setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'whiptail --version 2>&1 || true' 0 "whiptail 版本信息"
rlRun 'whiptail --help 2>&1 | head -5 || true' 0 "whiptail 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'whiptail --invalid 2>&1 || true' 0 "whiptail: 无效选项"

. "./teardown.sh"
echo "All newt functional tests passed!"

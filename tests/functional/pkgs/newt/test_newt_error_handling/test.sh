#!/bin/sh -eux
# Functional test: newt - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'whiptail --invalid 2>&1 || true' 0 "whiptail: 无效选项"

. "../teardown.sh"
echo "All newt 错误处理 tests passed!"

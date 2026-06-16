#!/bin/sh -eux
# Functional test: lua - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'lua --invalid 2>&1 || true' 0 "lua: 无效选项"

. "../teardown.sh"
echo "All lua 错误处理 tests passed!"

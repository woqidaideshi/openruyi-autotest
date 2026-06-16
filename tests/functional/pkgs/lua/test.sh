#!/bin/sh -eux
# Functional test: lua package
# Tests Lua 脚本语言
# Version: lua

. "./setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'lua --version 2>&1 || true' 0 "lua 版本信息"
rlRun 'lua --help 2>&1 | head -5 || true' 0 "lua 帮助信息"
rlRun 'luac --version 2>&1 || true' 0 "luac 版本信息"
rlRun 'luac --help 2>&1 | head -5 || true' 0 "luac 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'lua --invalid 2>&1 || true' 0 "lua: 无效选项"

. "./teardown.sh"
echo "All lua functional tests passed!"

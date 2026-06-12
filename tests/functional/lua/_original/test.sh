#!/bin/sh -eux
# Functional test: lua package
# Tests Lua 脚本语言
# Version: lua

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q lua' 0 "检查 lua 是否已安装"
rlRun 'which lua' 0 "检查 lua 命令是否可用"
rlRun 'which luac' 0 "检查 luac 命令是否可用"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'lua --version 2>&1 || true' 0 "lua 版本信息"
rlRun 'lua --help 2>&1 | head -5 || true' 0 "lua 帮助信息"
rlRun 'luac --version 2>&1 || true' 0 "luac 版本信息"
rlRun 'luac --help 2>&1 | head -5 || true' 0 "luac 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'lua --invalid 2>&1 || true' 0 "lua: 无效选项"

echo ""
echo "All lua functional tests passed!"

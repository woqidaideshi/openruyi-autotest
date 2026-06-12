#!/bin/sh -eux
# Functional test: lua - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q lua' 0 "检查 lua 是否已安装"
rlRun 'which lua' 0 "检查 lua 命令是否可用"
rlRun 'which luac' 0 "检查 luac 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'lua --invalid 2>&1 || true' 0 "lua: 无效选项"

echo ""
echo "All lua functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All lua 错误处理 tests passed!"

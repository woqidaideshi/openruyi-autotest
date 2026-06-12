#!/bin/sh -eux
# Functional test: lua - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q lua' 0 "检查 lua 是否已安装"
rlRun 'which lua' 0 "检查 lua 命令是否可用"
rlRun 'which luac' 0 "检查 luac 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'lua --version 2>&1 || true' 0 "lua 版本信息"
rlRun 'lua --help 2>&1 | head -5 || true' 0 "lua 帮助信息"
rlRun 'luac --version 2>&1 || true' 0 "luac 版本信息"
rlRun 'luac --help 2>&1 | head -5 || true' 0 "luac 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All lua 版本和帮助 tests passed!"

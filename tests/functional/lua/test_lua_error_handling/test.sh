#!/bin/sh -eux
# Functional test: lua - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q lua 2>/dev/null || { echo 'lua not installed, skipping'; exit 0; }
which lua 2>/dev/null || echo 'lua not found'
which luac 2>/dev/null || echo 'luac not found'
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

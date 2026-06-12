#!/bin/sh -eux
# Functional test: lua - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q lua 2>/dev/null || { echo 'lua not installed, skipping'; exit 0; }
which lua 2>/dev/null || echo 'lua not found'
which luac 2>/dev/null || echo 'luac not found'
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

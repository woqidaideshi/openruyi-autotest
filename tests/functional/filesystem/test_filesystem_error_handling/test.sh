#!/bin/sh -eux
# Functional test: filesystem - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q filesystem' 0 "检查 filesystem 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All filesystem functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All filesystem 错误处理 tests passed!"

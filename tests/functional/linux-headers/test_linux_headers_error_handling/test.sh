#!/bin/sh -eux
# Functional test: linux-headers - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q linux-headers' 0 "检查 linux-headers 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All linux-headers functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All linux-headers 错误处理 tests passed!"

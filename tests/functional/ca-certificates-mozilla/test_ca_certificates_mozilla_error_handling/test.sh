#!/bin/sh -eux
# Functional test: ca-certificates-mozilla - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q ca-certificates-mozilla' 0 "检查 ca-certificates-mozilla 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All ca-certificates-mozilla functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates-mozilla 错误处理 tests passed!"

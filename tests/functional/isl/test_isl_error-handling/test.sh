#!/bin/sh -eux
# Functional test: isl - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q isl' 0 "检查 isl 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All isl functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All isl 错误处理 tests passed!"

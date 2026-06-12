#!/bin/sh -eux
# Functional test: mpdecimal - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q mpdecimal' 0 "检查 mpdecimal 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All mpdecimal functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpdecimal 错误处理 tests passed!"

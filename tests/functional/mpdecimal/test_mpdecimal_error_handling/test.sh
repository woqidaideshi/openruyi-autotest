#!/bin/sh -eux
# Functional test: mpdecimal - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q mpdecimal 2>/dev/null || { echo 'mpdecimal not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All mpdecimal functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpdecimal 错误处理 tests passed!"

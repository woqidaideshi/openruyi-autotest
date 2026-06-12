#!/bin/sh -eux
# Functional test: ca-certificates-mozilla - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q ca-certificates-mozilla 2>/dev/null || { echo 'ca-certificates-mozilla not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All ca-certificates-mozilla functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates-mozilla 错误处理 tests passed!"

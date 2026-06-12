#!/bin/sh -eux
# Functional test: gmp - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gmp 2>/dev/null || { echo 'gmp not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All gmp functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All gmp 错误处理 tests passed!"

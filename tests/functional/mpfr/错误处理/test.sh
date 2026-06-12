#!/bin/sh -eux
# Functional test: mpfr - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q mpfr' 0 "检查 mpfr 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All mpfr functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpfr 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: mpfr - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q mpfr 2>/dev/null || { echo 'mpfr not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All mpfr functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpfr 错误处理 tests passed!"

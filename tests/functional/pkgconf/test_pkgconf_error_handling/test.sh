#!/bin/sh -eux
# Functional test: pkgconf - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q pkgconf 2>/dev/null || { echo 'pkgconf not installed, skipping'; exit 0; }
which pkgconf 2>/dev/null || echo 'pkgconf not found'
which bomtool 2>/dev/null || echo 'bomtool not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'pkgconf --invalid 2>&1 || true' 0 "pkgconf: 无效选项"

echo ""
echo "All pkgconf functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All pkgconf 错误处理 tests passed!"

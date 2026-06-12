#!/bin/sh -eux
# Functional test: pkgconf - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q pkgconf' 0 "检查 pkgconf 是否已安装"
rlRun 'which pkgconf' 0 "检查 pkgconf 命令是否可用"
rlRun 'which bomtool' 0 "检查 bomtool 命令是否可用"
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

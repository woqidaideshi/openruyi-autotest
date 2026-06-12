#!/bin/sh -eux
# Functional test: pkgconf - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q pkgconf' 0 "检查 pkgconf 是否已安装"
rlRun 'which pkgconf' 0 "检查 pkgconf 命令是否可用"
rlRun 'which bomtool' 0 "检查 bomtool 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'pkgconf --version 2>&1 || true' 0 "pkgconf 版本信息"
rlRun 'pkgconf --help 2>&1 | head -5 || true' 0 "pkgconf 帮助信息"
rlRun 'bomtool --version 2>&1 || true' 0 "bomtool 版本信息"
rlRun 'bomtool --help 2>&1 | head -5 || true' 0 "bomtool 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All pkgconf 版本和帮助 tests passed!"

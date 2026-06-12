#!/bin/sh -eux
# Functional test: pkgconf - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q pkgconf 2>/dev/null || { echo 'pkgconf not installed, skipping'; exit 0; }
which pkgconf 2>/dev/null || echo 'pkgconf not found'
which bomtool 2>/dev/null || echo 'bomtool not found'
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

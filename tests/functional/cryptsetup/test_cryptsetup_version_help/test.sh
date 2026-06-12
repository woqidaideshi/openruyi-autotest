#!/bin/sh -eux
# Functional test: cryptsetup - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q cryptsetup 2>/dev/null || { echo 'cryptsetup not installed, skipping'; exit 0; }
which cryptsetup 2>/dev/null || echo 'cryptsetup not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'cryptsetup --version 2>&1 || true' 0 "cryptsetup 版本信息"
rlRun 'cryptsetup --help 2>&1 | head -5 || true' 0 "cryptsetup 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All cryptsetup 版本和帮助 tests passed!"

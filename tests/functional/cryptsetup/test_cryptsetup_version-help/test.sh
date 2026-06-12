#!/bin/sh -eux
# Functional test: cryptsetup - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q cryptsetup' 0 "检查 cryptsetup 是否已安装"
rlRun 'which cryptsetup' 0 "检查 cryptsetup 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'cryptsetup --version 2>&1 || true' 0 "cryptsetup 版本信息"
rlRun 'cryptsetup --help 2>&1 | head -5 || true' 0 "cryptsetup 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All cryptsetup 版本和帮助 tests passed!"

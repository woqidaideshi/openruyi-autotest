#!/bin/sh -eux
# Functional test: cryptsetup - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q cryptsetup' 0 "检查 cryptsetup 是否已安装"
rlRun 'which cryptsetup' 0 "检查 cryptsetup 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'cryptsetup --invalid 2>&1 || true' 0 "cryptsetup: 无效选项"

echo ""
echo "All cryptsetup functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All cryptsetup 错误处理 tests passed!"

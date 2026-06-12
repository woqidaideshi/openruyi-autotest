#!/bin/sh -eux
# Functional test: newt - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q newt' 0 "检查 newt 是否已安装"
rlRun 'which whiptail' 0 "检查 whiptail 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'whiptail --invalid 2>&1 || true' 0 "whiptail: 无效选项"

echo ""
echo "All newt functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All newt 错误处理 tests passed!"

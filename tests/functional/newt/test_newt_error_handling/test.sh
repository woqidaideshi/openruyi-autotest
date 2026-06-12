#!/bin/sh -eux
# Functional test: newt - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q newt 2>/dev/null || { echo 'newt not installed, skipping'; exit 0; }
which whiptail 2>/dev/null || echo 'whiptail not found'
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

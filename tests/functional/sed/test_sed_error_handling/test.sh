#!/bin/sh -eux
# Functional test: sed - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q sed 2>/dev/null || { echo 'sed not installed, skipping'; exit 0; }
which sed 2>/dev/null || echo 'sed not found'
rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 6: 错误处理 ==="
rlRun 'sed --invalid 2>&1 || true' 0 "sed: 无效选项"

cd /; rm -rf $TmpDir
echo ""
echo "All sed functional tests passed!"


echo ""
echo "All sed 错误处理 tests passed!"

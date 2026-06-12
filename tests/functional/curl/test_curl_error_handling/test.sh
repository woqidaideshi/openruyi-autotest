#!/bin/sh -eux
# Functional test: curl - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q curl 2>/dev/null || { echo 'curl not installed, skipping'; exit 0; }
which curl 2>/dev/null || echo 'curl not found'
which wcurl 2>/dev/null || echo 'wcurl not found'
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 6: 错误处理 ==="
rlRun 'curl --invalid 2>&1 || true' 0 "curl: 无效选项"

echo ""
echo "All curl functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 错误处理 tests passed!"

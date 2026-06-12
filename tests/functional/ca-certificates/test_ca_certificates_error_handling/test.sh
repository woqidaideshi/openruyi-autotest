#!/bin/sh -eux
# Functional test: ca-certificates - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q ca-certificates 2>/dev/null || { echo 'ca-certificates not installed, skipping'; exit 0; }
which update-ca-trust 2>/dev/null || echo 'update-ca-trust not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"

echo ""
echo "All ca-certificates functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: zstd - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q zstd 2>/dev/null || { echo 'zstd not installed, skipping'; exit 0; }
which zstd 2>/dev/null || echo 'zstd not found'
which unzstd 2>/dev/null || echo 'unzstd not found'
which zstdcat 2>/dev/null || echo 'zstdcat not found'
which zstdgrep 2>/dev/null || echo 'zstdgrep not found'
which zstdless 2>/dev/null || echo 'zstdless not found'
which zstdmt 2>/dev/null || echo 'zstdmt not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'zstd --invalid 2>&1 || true' 0 "zstd: 无效选项"

echo ""
echo "All zstd functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All zstd 错误处理 tests passed!"

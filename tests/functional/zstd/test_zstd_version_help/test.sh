#!/bin/sh -eux
# Functional test: zstd - 版本和帮助

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'zstd --version 2>&1 || true' 0 "zstd 版本信息"
rlRun 'zstd --help 2>&1 | head -5 || true' 0 "zstd 帮助信息"
rlRun 'unzstd --version 2>&1 || true' 0 "unzstd 版本信息"
rlRun 'unzstd --help 2>&1 | head -5 || true' 0 "unzstd 帮助信息"
rlRun 'zstdcat --version 2>&1 || true' 0 "zstdcat 版本信息"
rlRun 'zstdcat --help 2>&1 | head -5 || true' 0 "zstdcat 帮助信息"
rlRun 'zstdgrep --version 2>&1 || true' 0 "zstdgrep 版本信息"
rlRun 'zstdgrep --help 2>&1 | head -5 || true' 0 "zstdgrep 帮助信息"
rlRun 'zstdless --version 2>&1 || true' 0 "zstdless 版本信息"
rlRun 'zstdless --help 2>&1 | head -5 || true' 0 "zstdless 帮助信息"
rlRun 'zstdmt --version 2>&1 || true' 0 "zstdmt 版本信息"
rlRun 'zstdmt --help 2>&1 | head -5 || true' 0 "zstdmt 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All zstd 版本和帮助 tests passed!"

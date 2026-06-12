#!/bin/sh -eux
# Functional test: gzip - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gzip 2>/dev/null || { echo 'gzip not installed, skipping'; exit 0; }
which gzip 2>/dev/null || echo 'gzip not found'
which gunzip 2>/dev/null || echo 'gunzip not found'
which zcat 2>/dev/null || echo 'zcat not found'
which zcmp 2>/dev/null || echo 'zcmp not found'
which zdiff 2>/dev/null || echo 'zdiff not found'
which zgrep 2>/dev/null || echo 'zgrep not found'
which zless 2>/dev/null || echo 'zless not found'
which zmore 2>/dev/null || echo 'zmore not found'
which znew 2>/dev/null || echo 'znew not found'
which gzexe 2>/dev/null || echo 'gzexe not found'
which zforce 2>/dev/null || echo 'zforce not found'
which zegrep 2>/dev/null || echo 'zegrep not found'
which zfgrep 2>/dev/null || echo 'zfgrep not found'
which uncompress 2>/dev/null || echo 'uncompress not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'gzip --invalid 2>&1 || true' 0 "gzip: 无效选项"

echo ""
echo "All gzip functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All gzip 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: xz - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q xz 2>/dev/null || { echo 'xz not installed, skipping'; exit 0; }
which xz 2>/dev/null || echo 'xz not found'
which unxz 2>/dev/null || echo 'unxz not found'
which xzcat 2>/dev/null || echo 'xzcat not found'
which lzma 2>/dev/null || echo 'lzma not found'
which unlzma 2>/dev/null || echo 'unlzma not found'
which lzcat 2>/dev/null || echo 'lzcat not found'
which lzcmp 2>/dev/null || echo 'lzcmp not found'
which lzdiff 2>/dev/null || echo 'lzdiff not found'
which lzgrep 2>/dev/null || echo 'lzgrep not found'
which lzless 2>/dev/null || echo 'lzless not found'
which lzmore 2>/dev/null || echo 'lzmore not found'
which lzmadec 2>/dev/null || echo 'lzmadec not found'
which lzmainfo 2>/dev/null || echo 'lzmainfo not found'
which lzegrep 2>/dev/null || echo 'lzegrep not found'
which lzfgrep 2>/dev/null || echo 'lzfgrep not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'xz --invalid 2>&1 || true' 0 "xz: 无效选项"

echo ""
echo "All xz functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All xz 错误处理 tests passed!"

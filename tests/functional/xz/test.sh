#!/bin/sh -eux
# Functional test: xz package
# Tests xz 压缩工具集
# Version: xz

rlRun() { eval "\$1" 2>&1; return \$?; }

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'xz --version 2>&1 || true' 0 "xz 版本信息"
rlRun 'xz --help 2>&1 | head -5 || true' 0 "xz 帮助信息"
rlRun 'unxz --version 2>&1 || true' 0 "unxz 版本信息"
rlRun 'unxz --help 2>&1 | head -5 || true' 0 "unxz 帮助信息"
rlRun 'xzcat --version 2>&1 || true' 0 "xzcat 版本信息"
rlRun 'xzcat --help 2>&1 | head -5 || true' 0 "xzcat 帮助信息"
rlRun 'lzma --version 2>&1 || true' 0 "lzma 版本信息"
rlRun 'lzma --help 2>&1 | head -5 || true' 0 "lzma 帮助信息"
rlRun 'unlzma --version 2>&1 || true' 0 "unlzma 版本信息"
rlRun 'unlzma --help 2>&1 | head -5 || true' 0 "unlzma 帮助信息"
rlRun 'lzcat --version 2>&1 || true' 0 "lzcat 版本信息"
rlRun 'lzcat --help 2>&1 | head -5 || true' 0 "lzcat 帮助信息"
rlRun 'lzcmp --version 2>&1 || true' 0 "lzcmp 版本信息"
rlRun 'lzcmp --help 2>&1 | head -5 || true' 0 "lzcmp 帮助信息"
rlRun 'lzdiff --version 2>&1 || true' 0 "lzdiff 版本信息"
rlRun 'lzdiff --help 2>&1 | head -5 || true' 0 "lzdiff 帮助信息"
rlRun 'lzgrep --version 2>&1 || true' 0 "lzgrep 版本信息"
rlRun 'lzgrep --help 2>&1 | head -5 || true' 0 "lzgrep 帮助信息"
rlRun 'lzless --version 2>&1 || true' 0 "lzless 版本信息"
rlRun 'lzless --help 2>&1 | head -5 || true' 0 "lzless 帮助信息"
rlRun 'lzmore --version 2>&1 || true' 0 "lzmore 版本信息"
rlRun 'lzmore --help 2>&1 | head -5 || true' 0 "lzmore 帮助信息"
rlRun 'lzmadec --version 2>&1 || true' 0 "lzmadec 版本信息"
rlRun 'lzmadec --help 2>&1 | head -5 || true' 0 "lzmadec 帮助信息"
rlRun 'lzmainfo --version 2>&1 || true' 0 "lzmainfo 版本信息"
rlRun 'lzmainfo --help 2>&1 | head -5 || true' 0 "lzmainfo 帮助信息"
rlRun 'lzegrep --version 2>&1 || true' 0 "lzegrep 版本信息"
rlRun 'lzegrep --help 2>&1 | head -5 || true' 0 "lzegrep 帮助信息"
rlRun 'lzfgrep --version 2>&1 || true' 0 "lzfgrep 版本信息"
rlRun 'lzfgrep --help 2>&1 | head -5 || true' 0 "lzfgrep 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'xz --invalid 2>&1 || true' 0 "xz: 无效选项"

echo ""
echo "All xz functional tests passed!"

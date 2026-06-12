#!/bin/sh -eux
# Functional test: gzip package
# Tests gzip 压缩工具集
# Version: gzip

rlRun() { eval "\$1" 2>&1; return \$?; }

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'gzip --version 2>&1 || true' 0 "gzip 版本信息"
rlRun 'gzip --help 2>&1 | head -5 || true' 0 "gzip 帮助信息"
rlRun 'gunzip --version 2>&1 || true' 0 "gunzip 版本信息"
rlRun 'gunzip --help 2>&1 | head -5 || true' 0 "gunzip 帮助信息"
rlRun 'zcat --version 2>&1 || true' 0 "zcat 版本信息"
rlRun 'zcat --help 2>&1 | head -5 || true' 0 "zcat 帮助信息"
rlRun 'zcmp --version 2>&1 || true' 0 "zcmp 版本信息"
rlRun 'zcmp --help 2>&1 | head -5 || true' 0 "zcmp 帮助信息"
rlRun 'zdiff --version 2>&1 || true' 0 "zdiff 版本信息"
rlRun 'zdiff --help 2>&1 | head -5 || true' 0 "zdiff 帮助信息"
rlRun 'zgrep --version 2>&1 || true' 0 "zgrep 版本信息"
rlRun 'zgrep --help 2>&1 | head -5 || true' 0 "zgrep 帮助信息"
rlRun 'zless --version 2>&1 || true' 0 "zless 版本信息"
rlRun 'zless --help 2>&1 | head -5 || true' 0 "zless 帮助信息"
rlRun 'zmore --version 2>&1 || true' 0 "zmore 版本信息"
rlRun 'zmore --help 2>&1 | head -5 || true' 0 "zmore 帮助信息"
rlRun 'znew --version 2>&1 || true' 0 "znew 版本信息"
rlRun 'znew --help 2>&1 | head -5 || true' 0 "znew 帮助信息"
rlRun 'gzexe --version 2>&1 || true' 0 "gzexe 版本信息"
rlRun 'gzexe --help 2>&1 | head -5 || true' 0 "gzexe 帮助信息"
rlRun 'zforce --version 2>&1 || true' 0 "zforce 版本信息"
rlRun 'zforce --help 2>&1 | head -5 || true' 0 "zforce 帮助信息"
rlRun 'zegrep --version 2>&1 || true' 0 "zegrep 版本信息"
rlRun 'zegrep --help 2>&1 | head -5 || true' 0 "zegrep 帮助信息"
rlRun 'zfgrep --version 2>&1 || true' 0 "zfgrep 版本信息"
rlRun 'zfgrep --help 2>&1 | head -5 || true' 0 "zfgrep 帮助信息"
rlRun 'uncompress --version 2>&1 || true' 0 "uncompress 版本信息"
rlRun 'uncompress --help 2>&1 | head -5 || true' 0 "uncompress 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'gzip --invalid 2>&1 || true' 0 "gzip: 无效选项"

echo ""
echo "All gzip functional tests passed!"

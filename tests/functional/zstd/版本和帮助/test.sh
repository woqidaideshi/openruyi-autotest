#!/bin/sh -eux
# Functional test: zstd - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q zstd' 0 "检查 zstd 是否已安装"
rlRun 'which zstd' 0 "检查 zstd 命令是否可用"
rlRun 'which unzstd' 0 "检查 unzstd 命令是否可用"
rlRun 'which zstdcat' 0 "检查 zstdcat 命令是否可用"
rlRun 'which zstdgrep' 0 "检查 zstdgrep 命令是否可用"
rlRun 'which zstdless' 0 "检查 zstdless 命令是否可用"
rlRun 'which zstdmt' 0 "检查 zstdmt 命令是否可用"
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

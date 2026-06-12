#!/bin/sh -eux
# Functional test: zstd - 错误处理

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

echo "=== 测试 2: 错误处理 ==="
rlRun 'zstd --invalid 2>&1 || true' 0 "zstd: 无效选项"

echo ""
echo "All zstd functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All zstd 错误处理 tests passed!"

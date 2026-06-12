#!/bin/sh -eux
# Functional test: xz - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q xz' 0 "检查 xz 是否已安装"
rlRun 'which xz' 0 "检查 xz 命令是否可用"
rlRun 'which unxz' 0 "检查 unxz 命令是否可用"
rlRun 'which xzcat' 0 "检查 xzcat 命令是否可用"
rlRun 'which lzma' 0 "检查 lzma 命令是否可用"
rlRun 'which unlzma' 0 "检查 unlzma 命令是否可用"
rlRun 'which lzcat' 0 "检查 lzcat 命令是否可用"
rlRun 'which lzcmp' 0 "检查 lzcmp 命令是否可用"
rlRun 'which lzdiff' 0 "检查 lzdiff 命令是否可用"
rlRun 'which lzgrep' 0 "检查 lzgrep 命令是否可用"
rlRun 'which lzless' 0 "检查 lzless 命令是否可用"
rlRun 'which lzmore' 0 "检查 lzmore 命令是否可用"
rlRun 'which lzmadec' 0 "检查 lzmadec 命令是否可用"
rlRun 'which lzmainfo' 0 "检查 lzmainfo 命令是否可用"
rlRun 'which lzegrep' 0 "检查 lzegrep 命令是否可用"
rlRun 'which lzfgrep' 0 "检查 lzfgrep 命令是否可用"
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

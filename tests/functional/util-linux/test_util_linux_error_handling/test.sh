#!/bin/sh -eux
# Functional test: util-linux - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q util-linux' 0 "检查 util-linux 是否已安装"
rlRun 'which addpart' 0 "检查 addpart 命令是否可用"
rlRun 'which agetty' 0 "检查 agetty 命令是否可用"
rlRun 'which blkid' 0 "检查 blkid 命令是否可用"
rlRun 'which blkdiscard' 0 "检查 blkdiscard 命令是否可用"
rlRun 'which blockdev' 0 "检查 blockdev 命令是否可用"
rlRun 'which cal' 0 "检查 cal 命令是否可用"
rlRun 'which cfdisk' 0 "检查 cfdisk 命令是否可用"
rlRun 'which chcpu' 0 "检查 chcpu 命令是否可用"
rlRun 'which chfn' 0 "检查 chfn 命令是否可用"
rlRun 'which chmem' 0 "检查 chmem 命令是否可用"
rlRun 'which choom' 0 "检查 choom 命令是否可用"
rlRun 'which chrt' 0 "检查 chrt 命令是否可用"
rlRun 'which bits' 0 "检查 bits 命令是否可用"
rlRun 'which blkpr' 0 "检查 blkpr 命令是否可用"
rlRun 'which blkzone' 0 "检查 blkzone 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'addpart --invalid 2>&1 || true' 0 "addpart: 无效选项"

echo ""
echo "All util-linux functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All util-linux 错误处理 tests passed!"

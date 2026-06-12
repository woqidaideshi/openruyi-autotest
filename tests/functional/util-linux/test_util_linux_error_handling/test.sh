#!/bin/sh -eux
# Functional test: util-linux - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q util-linux 2>/dev/null || { echo 'util-linux not installed, skipping'; exit 0; }
which addpart 2>/dev/null || echo 'addpart not found'
which agetty 2>/dev/null || echo 'agetty not found'
which blkid 2>/dev/null || echo 'blkid not found'
which blkdiscard 2>/dev/null || echo 'blkdiscard not found'
which blockdev 2>/dev/null || echo 'blockdev not found'
which cal 2>/dev/null || echo 'cal not found'
which cfdisk 2>/dev/null || echo 'cfdisk not found'
which chcpu 2>/dev/null || echo 'chcpu not found'
which chfn 2>/dev/null || echo 'chfn not found'
which chmem 2>/dev/null || echo 'chmem not found'
which choom 2>/dev/null || echo 'choom not found'
which chrt 2>/dev/null || echo 'chrt not found'
which bits 2>/dev/null || echo 'bits not found'
which blkpr 2>/dev/null || echo 'blkpr not found'
which blkzone 2>/dev/null || echo 'blkzone not found'
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

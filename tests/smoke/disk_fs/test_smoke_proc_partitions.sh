#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'cat /proc/partitions' 0 "/proc/partitions 分区列表"
rlRun 'cat /proc/filesystems | head -5' 0 "/proc/filesystems 支持的文件系统"
echo "smoke test passed!"

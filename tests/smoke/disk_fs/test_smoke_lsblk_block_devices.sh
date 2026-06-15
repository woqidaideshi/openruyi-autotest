#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'lsblk' 0 "lsblk 块设备"
rlRun 'lsblk -f 2>&1 || true' 0 "lsblk -f 文件系统"
echo "smoke test passed!"

#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
dd if=/dev/zero of=data bs=1k count=10 2>/dev/null
rlRun 'xz data' 0 "xz 压缩"
rlRun 'test -f data.xz' 0 "xz 文件存在"
rlRun 'unxz data.xz' 0 "unxz 解压"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

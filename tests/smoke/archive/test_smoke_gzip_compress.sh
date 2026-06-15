#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
dd if=/dev/zero of=big.txt bs=1k count=10 2>/dev/null
rlRun 'gzip big.txt' 0 "gzip 压缩"
rlRun 'test -f big.txt.gz' 0 "压缩文件存在"
rlRun 'gunzip big.txt.gz' 0 "gunzip 解压"
rlRun 'test -f big.txt' 0 "解压文件恢复"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

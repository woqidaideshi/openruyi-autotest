#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
rlRun 'touch empty.txt' 0 "touch 创建空文件"
rlRun 'test -f empty.txt' 0 "空文件存在"
rlRun 'test ! -s empty.txt' 0 "文件大小为0"
rlRun 'touch -t 202401010000 ref.txt' 0 "touch 设置时间戳"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
mkdir data; echo "content" > data/file.txt
rlRun 'tar -cJf data.tar.xz data' 0 "tar -cJf 创建tar.xz"
rlRun 'test -f data.tar.xz' 0 "tar.xz 文件存在"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
mkdir src; echo "a" > src/a.txt; echo "b" > src/b.txt
rlRun 'tar -cf test.tar src' 0 "tar 创建归档"
rlRun 'test -f test.tar' 0 "tar 文件已创建"
rlRun 'tar -tf test.tar | grep a.txt' 0 "tar -t 列出内容"
mkdir extract; cd extract
rlRun 'tar -xf ../test.tar' 0 "tar -x 解压"
rlRun 'test -f src/a.txt' 0 "解压文件存在"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

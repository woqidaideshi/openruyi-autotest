#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "data" > src.txt
rlRun 'cp src.txt dst.txt' 0 "cp 复制文件"
rlRun 'diff src.txt dst.txt' 0 "验证复制一致"
mkdir sub; echo "nested" > sub/f.txt
rlRun 'cp -r sub sub2' 0 "cp -r 递归复制目录"
rlRun 'test -f sub2/f.txt' 0 "子目录文件存在"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

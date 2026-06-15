#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "data" | tee out.txt > /dev/null
rlRun 'test -f out.txt' 0 "tee 写入文件"
rlRun 'grep data out.txt' 0 "tee 内容正确"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

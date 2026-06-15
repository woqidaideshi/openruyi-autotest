#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "data" > out.txt
rlRun 'cat out.txt | wc -l' 0 "管道 | 连接命令"
echo "more" >> out.txt
rlRun 'wc -l < out.txt' 0 "重定向 < 输入"
rlRun 'grep data out.txt > /dev/null 2>&1' 0 "重定向到 /dev/null"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "line1" > f.txt
rlRun 'cat f.txt' 0 "cat 读取文件"
rlRun 'cat /etc/os-release | head -3' 0 "cat 系统文件"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

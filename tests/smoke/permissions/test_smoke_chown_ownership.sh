#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
touch own.txt
rlRun 'chown $(whoami) own.txt' 0 "chown 设置所有者"
rlRun 'test -O own.txt' 0 "文件属于当前用户"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "move me" > old.txt
rlRun 'mv old.txt new.txt' 0 "mv 重命名"
rlRun 'test -f new.txt -a ! -f old.txt' 0 "旧文件已不存在"
mkdir dest
rlRun 'mv new.txt dest/' 0 "mv 移动到目录"
rlRun 'test -f dest/new.txt' 0 "文件已移动"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

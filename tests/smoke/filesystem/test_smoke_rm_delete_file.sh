#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
touch rm_test.txt; mkdir rm_dir
rlRun 'rm rm_test.txt' 0 "rm 删除文件"
rlRun 'test ! -f rm_test.txt' 0 "文件已删除"
rlRun 'rm -rf rm_dir' 0 "rm -rf 删除目录"
rlRun 'test ! -d rm_dir' 0 "目录已删除"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

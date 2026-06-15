#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "a" > f1; echo "b" > f2
rlRun 'diff f1 f2' 1 "diff 检测不同"
echo "a" > f3; echo "a" > f4
rlRun 'diff f3 f4' 0 "diff 相同文件"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
touch found.txt; mkdir sub
rlRun 'find . -name "found.txt"' 0 "find 按名称查找"
rlRun 'find . -type d' 0 "find 按类型查目录"
rlRun 'find . -type f' 0 "find 按类型查文件"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

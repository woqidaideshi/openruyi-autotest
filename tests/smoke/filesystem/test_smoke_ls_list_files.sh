#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "hello" > a.txt; mkdir subdir
rlRun 'ls' 0 "ls 列出当前目录"
rlRun 'ls -la' 0 "ls -la 详细列出"
rlRun 'ls -l a.txt' 0 "ls 指定文件"
rlRun 'ls -d subdir' 0 "ls -d 列出目录本身"
rlRun 'ls /tmp' 0 "ls 列出系统目录"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

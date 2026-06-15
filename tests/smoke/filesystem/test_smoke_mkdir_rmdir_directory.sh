#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
rlRun 'mkdir newdir' 0 "mkdir 创建目录"
rlRun 'test -d newdir' 0 "目录存在"
rlRun 'mkdir -p a/b/c' 0 "mkdir -p 创建嵌套目录"
rlRun 'test -d a/b/c' 0 "嵌套目录存在"
rlRun 'rmdir newdir' 0 "rmdir 删除空目录"
mkdir nonempty; touch nonempty/f
rlRun 'rm -rf nonempty' 0 "rm -rf 删除非空目录"
cd /; rm -rf $TmpDir
echo "smoke test passed!"

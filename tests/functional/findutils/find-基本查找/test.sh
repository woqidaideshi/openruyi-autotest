#!/bin/sh -eux
# Functional test: findutils - find-基本查找

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q findutils' 0 "检查 findutils 是否已安装"
rlRun 'which find' 0 "检查 find 命令是否可用"
rlRun 'which xargs' 0 "检查 xargs 命令是否可用"
rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 1: find 基本查找 ==="
mkdir -p a/b/c
touch a/f1.txt a/f2.txt a/b/f3.txt
rlRun 'find . -name "*.txt"' 0 "find -name: 按名称查找"
rlRun 'find . -type f' 0 "find -type f: 查找文件"
rlRun 'find . -type d' 0 "find -type d: 查找目录"


echo ""
echo "All findutils find-基本查找 tests passed!"

#!/bin/sh -eux
# Functional test: sed - 基本替换

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sed' 0 "检查 sed 是否已安装"
rlRun 'which sed' 0 "检查 sed 命令是否可用"
rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 1: 基本替换 ==="
echo "hello world" > test.txt
rlRun 'sed "s/world/sed/" test.txt' 0 "sed s: 基本替换"
rlRun 'sed "s/hello/HI/" test.txt' 0 "sed s: 替换hello"


echo ""
echo "All sed 基本替换 tests passed!"

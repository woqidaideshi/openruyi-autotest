#!/bin/sh -eux
# Functional test: sed - 多表达式

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sed' 0 "检查 sed 是否已安装"
rlRun 'which sed' 0 "检查 sed 命令是否可用"
rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 5: 多表达式 ==="
rlRun 'echo "abc" | sed -e "s/a/A/" -e "s/c/C/"' 0 "sed -e: 多表达式"


echo ""
echo "All sed 多表达式 tests passed!"

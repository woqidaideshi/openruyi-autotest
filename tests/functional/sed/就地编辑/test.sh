#!/bin/sh -eux
# Functional test: sed - 就地编辑

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sed' 0 "检查 sed 是否已安装"
rlRun 'which sed' 0 "检查 sed 命令是否可用"
rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 4: 就地编辑 ==="
echo "original" > edit.txt
rlRun 'sed -i "s/original/modified/" edit.txt' 0 "sed -i: 就地编辑"
rlRun 'grep modified edit.txt' 0 "sed -i: 验证修改"


echo ""
echo "All sed 就地编辑 tests passed!"

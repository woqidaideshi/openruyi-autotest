#!/bin/sh -eux
# Functional test: findutils - xargs

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q findutils 2>/dev/null || { echo 'findutils not installed, skipping'; exit 0; }
which find 2>/dev/null || echo 'find not found'
which xargs 2>/dev/null || echo 'xargs not found'
rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 4: xargs ==="
echo -e "1\n2\n3" > nums.txt
rlRun 'cat nums.txt | xargs echo' 0 "xargs: 基本用法"
rlRun 'echo "test1 test2" | xargs -n1 echo' 0 "xargs -n1: 每次一个参数"


echo ""
echo "All findutils xargs tests passed!"

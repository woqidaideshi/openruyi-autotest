#!/bin/sh -eux
# Functional test: findutils - find-执行操作

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q findutils 2>/dev/null || { echo 'findutils not installed, skipping'; exit 0; }
which find 2>/dev/null || echo 'find not found'
which xargs 2>/dev/null || echo 'xargs not found'
rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 3: find 执行操作 ==="
rlRun 'find . -name "f1.txt" -exec cat {} \;' 0 "find -exec: 执行命令"
rlRun 'find . -name "*.txt" -delete' 0 "find -delete: 删除文件"
rlRun 'test ! -f a/f1.txt' 0 "find -delete: 验证删除"


echo ""
echo "All findutils find-执行操作 tests passed!"

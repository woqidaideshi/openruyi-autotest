#!/bin/sh -eux
# Functional test: findutils - find-选项

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q findutils 2>/dev/null || { echo 'findutils not installed, skipping'; exit 0; }
which find 2>/dev/null || echo 'find not found'
which xargs 2>/dev/null || echo 'xargs not found'
rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 2: find 选项 ==="
rlRun 'find . -maxdepth 1 -name "*.txt"' 0 "find -maxdepth: 最大深度"
rlRun 'find . -mindepth 2' 0 "find -mindepth: 最小深度"
rlRun 'find . -empty' 0 "find -empty: 空文件/目录"
rlRun 'find . -size +0c' 0 "find -size: 按大小"


echo ""
echo "All findutils find-选项 tests passed!"

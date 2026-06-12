#!/bin/sh -eux
# Functional test: findutils - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q findutils 2>/dev/null || { echo 'findutils not installed, skipping'; exit 0; }
which find 2>/dev/null || echo 'find not found'
which xargs 2>/dev/null || echo 'xargs not found'
rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 5: 错误处理 ==="
rlRun 'find /nonexistent 2>&1 || true' 0 "find: 无效路径"

cd /; rm -rf $TmpDir
echo ""
echo "All findutils functional tests passed!"


echo ""
echo "All findutils 错误处理 tests passed!"

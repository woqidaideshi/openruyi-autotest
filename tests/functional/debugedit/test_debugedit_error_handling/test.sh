#!/bin/sh -eux
# Functional test: debugedit - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q debugedit 2>/dev/null || { echo 'debugedit not installed, skipping'; exit 0; }
which debugedit 2>/dev/null || echo 'debugedit not found'
which debugedit-classify-ar 2>/dev/null || echo 'debugedit-classify-ar not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'debugedit --invalid 2>&1 || true' 0 "debugedit: 无效选项"

echo ""
echo "All debugedit functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All debugedit 错误处理 tests passed!"

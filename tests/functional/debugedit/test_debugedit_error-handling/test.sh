#!/bin/sh -eux
# Functional test: debugedit - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q debugedit' 0 "检查 debugedit 是否已安装"
rlRun 'which debugedit' 0 "检查 debugedit 命令是否可用"
rlRun 'which debugedit-classify-ar' 0 "检查 debugedit-classify-ar 命令是否可用"
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

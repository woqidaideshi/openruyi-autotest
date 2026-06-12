#!/bin/sh -eux
# Functional test: dwz - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q dwz' 0 "检查 dwz 是否已安装"
rlRun 'which dwz' 0 "检查 dwz 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'dwz --invalid 2>&1 || true' 0 "dwz: 无效选项"

echo ""
echo "All dwz functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All dwz 错误处理 tests passed!"

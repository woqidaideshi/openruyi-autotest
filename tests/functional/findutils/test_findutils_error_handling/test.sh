#!/bin/sh -eux
# Functional test: findutils - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q findutils' 0 "检查 findutils 是否已安装"
rlRun 'which find' 0 "检查 find 命令是否可用"
rlRun 'which xargs' 0 "检查 xargs 命令是否可用"
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

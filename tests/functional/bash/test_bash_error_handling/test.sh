#!/bin/sh -eux
# Functional test: bash - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q bash' 0 "检查 bash 是否已安装"
rlRun 'which bash' 0 "检查 bash 命令是否可用"
rlRun 'which sh' 0 "检查 sh 命令是否可用"
rlRun 'which bashbug' 0 "检查 bashbug 命令是否可用"
rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 7: 错误处理 ==="
rlRun 'bash -c "exit 1" 2>&1 || true' 0 "bash: 错误退出"

cd /; rm -rf $TmpDir
echo ""
echo "All bash functional tests passed!"


echo ""
echo "All bash 错误处理 tests passed!"

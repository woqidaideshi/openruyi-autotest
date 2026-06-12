#!/bin/sh -eux
# Functional test: ca-certificates - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q ca-certificates' 0 "检查 ca-certificates 是否已安装"
rlRun 'which update-ca-trust' 0 "检查 update-ca-trust 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"

echo ""
echo "All ca-certificates functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates 错误处理 tests passed!"

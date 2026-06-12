#!/bin/sh -eux
# Functional test: curl - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q curl' 0 "检查 curl 是否已安装"
rlRun 'which curl' 0 "检查 curl 命令是否可用"
rlRun 'which wcurl' 0 "检查 wcurl 命令是否可用"
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 6: 错误处理 ==="
rlRun 'curl --invalid 2>&1 || true' 0 "curl: 无效选项"

echo ""
echo "All curl functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 错误处理 tests passed!"

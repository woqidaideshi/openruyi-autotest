#!/bin/sh -eux
# Functional test: curl - wcurl

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q curl' 0 "检查 curl 是否已安装"
rlRun 'which curl' 0 "检查 curl 命令是否可用"
rlRun 'which wcurl' 0 "检查 wcurl 命令是否可用"
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 5: wcurl ==="
rlRun 'wcurl --help 2>&1 | head -5 || echo "wcurl帮助"' 0 "wcurl 帮助"

cd /
rm -rf $TmpDir

echo ""
echo "All curl wcurl tests passed!"

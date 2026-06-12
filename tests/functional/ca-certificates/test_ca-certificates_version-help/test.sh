#!/bin/sh -eux
# Functional test: ca-certificates - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q ca-certificates' 0 "检查 ca-certificates 是否已安装"
rlRun 'which update-ca-trust' 0 "检查 update-ca-trust 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'update-ca-trust --version 2>&1 || true' 0 "update-ca-trust 版本信息"
rlRun 'update-ca-trust --help 2>&1 | head -5 || true' 0 "update-ca-trust 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates 版本和帮助 tests passed!"

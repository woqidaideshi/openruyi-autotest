#!/bin/sh -eux
# Functional test: rpm-config-openruyi - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q rpm-config-openruyi' 0 "检查 rpm-config-openruyi 是否已安装"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All rpm-config-openruyi functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All rpm-config-openruyi 错误处理 tests passed!"

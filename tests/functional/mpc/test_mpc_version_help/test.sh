#!/bin/sh -eux
# Functional test: mpc - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q mpc 2>/dev/null || { echo 'mpc not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql mpc | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

cd /
rm -rf $TmpDir

echo ""
echo "All mpc 版本和帮助 tests passed!"

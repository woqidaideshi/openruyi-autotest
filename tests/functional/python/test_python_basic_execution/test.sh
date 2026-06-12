#!/bin/sh -eux
# Functional test: python - 基本执行

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q python3' 0 "检查 python3 是否已安装"
rlRun 'which python3' 0 "检查 python3 命令是否可用"
rlRun 'python3 --version' 0 "Python 版本"
rlRun 'which python3' 0 "python3 可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 基本执行 ==="
rlRun 'python3 -c "print(1+2)"' 0 "Python 基本运算"
rlRun 'python3 -c "import sys; print(sys.version)"' 0 "Python sys模块"

cd /
rm -rf $TmpDir

echo ""
echo "All python 基本执行 tests passed!"

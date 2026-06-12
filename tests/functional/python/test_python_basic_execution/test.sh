#!/bin/sh -eux
# Functional test: python - 基本执行

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q python3 2>/dev/null || { echo 'python3 not installed, skipping'; exit 0; }
which python3 2>/dev/null || echo 'python3 not found'
rlRun 'python3 --version' 0 "Python 版本"
which python3 2>/dev/null || echo 'python3 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 基本执行 ==="
rlRun 'python3 -c "print(1+2)"' 0 "Python 基本运算"
rlRun 'python3 -c "import sys; print(sys.version)"' 0 "Python sys模块"

cd /
rm -rf $TmpDir

echo ""
echo "All python 基本执行 tests passed!"

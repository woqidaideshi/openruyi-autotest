#!/bin/sh -eux
# Functional test: python - 脚本执行

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q python3 2>/dev/null || { echo 'python3 not installed, skipping'; exit 0; }
which python3 2>/dev/null || echo 'python3 not found'
rlRun 'python3 --version' 0 "Python 版本"
which python3 2>/dev/null || echo 'python3 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 3: 脚本执行 ==="
TmpDir=$(mktemp -d); cd $TmpDir
echo 'print("hello python")' > test.py
rlRun 'python3 test.py' 0 "python3 执行脚本"

cd /
rm -rf $TmpDir

echo ""
echo "All python 脚本执行 tests passed!"

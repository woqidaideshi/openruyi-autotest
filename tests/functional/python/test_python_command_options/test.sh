#!/bin/sh -eux
# Functional test: python - 命令行选项

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q python3 2>/dev/null || { echo 'python3 not installed, skipping'; exit 0; }
which python3 2>/dev/null || echo 'python3 not found'
rlRun 'python3 --version' 0 "Python 版本"
which python3 2>/dev/null || echo 'python3 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 命令行选项 ==="
rlRun 'python3 -h 2>&1 | head -5' 0 "python3 -h: 帮助"
rlRun 'python3 -V' 0 "python3 -V: 版本"
rlRun 'python3 -c "import os; print(os.name)"' 0 "python3: os模块"

cd /
rm -rf $TmpDir

echo ""
echo "All python 命令行选项 tests passed!"

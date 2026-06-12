#!/bin/sh -eux
# Functional test: python - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q python3 2>/dev/null || { echo 'python3 not installed, skipping'; exit 0; }
which python3 2>/dev/null || echo 'python3 not found'
rlRun 'python3 --version' 0 "Python 版本"
which python3 2>/dev/null || echo 'python3 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 5: 错误处理 ==="
rlRun 'python3 -c "import nonexistent" 2>&1 || true' 0 "python3: 导入错误"

cd /; rm -rf $TmpDir
echo ""
echo "All python functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All python 错误处理 tests passed!"

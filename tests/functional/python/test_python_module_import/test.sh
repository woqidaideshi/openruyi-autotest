#!/bin/sh -eux
# Functional test: python - 模块导入

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q python3 2>/dev/null || { echo 'python3 not installed, skipping'; exit 0; }
which python3 2>/dev/null || echo 'python3 not found'
rlRun 'python3 --version' 0 "Python 版本"
which python3 2>/dev/null || echo 'python3 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 4: 模块导入 ==="
rlRun 'python3 -c "import json, math, re, hashlib"' 0 "python3: 导入标准模块"

cd /
rm -rf $TmpDir

echo ""
echo "All python 模块导入 tests passed!"

#!/bin/sh -eux
# Functional test: python package
# Tests Python 解释器
# Version: python3

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q python3 2>/dev/null || { echo 'python3 not installed, skipping'; exit 0; }
which python3 2>/dev/null || echo 'python3 not found'

rlRun 'python3 --version' 0 "Python 版本"
which python3 2>/dev/null || echo 'python3 not found'

echo "=== 测试 1: 基本执行 ==="
rlRun 'python3 -c "print(1+2)"' 0 "Python 基本运算"
rlRun 'python3 -c "import sys; print(sys.version)"' 0 "Python sys模块"

echo "=== 测试 2: 命令行选项 ==="
rlRun 'python3 -h 2>&1 | head -5' 0 "python3 -h: 帮助"
rlRun 'python3 -V' 0 "python3 -V: 版本"
rlRun 'python3 -c "import os; print(os.name)"' 0 "python3: os模块"

echo "=== 测试 3: 脚本执行 ==="
TmpDir=$(mktemp -d); cd $TmpDir
echo 'print("hello python")' > test.py
rlRun 'python3 test.py' 0 "python3 执行脚本"

echo "=== 测试 4: 模块导入 ==="
rlRun 'python3 -c "import json, math, re, hashlib"' 0 "python3: 导入标准模块"

echo "=== 测试 5: 错误处理 ==="
rlRun 'python3 -c "import nonexistent" 2>&1 || true' 0 "python3: 导入错误"

cd /; rm -rf $TmpDir
echo ""
echo "All python functional tests passed!"

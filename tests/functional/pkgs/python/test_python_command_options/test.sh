#!/bin/sh -eux
# Functional test: python - 命令行选项

. "../setup.sh"

echo "=== 测试 2: 命令行选项 ==="
rlRun 'python3 -h 2>&1 | head -5' 0 "python3 -h: 帮助"
rlRun 'python3 -V' 0 "python3 -V: 版本"
rlRun 'python3 -c "import os; print(os.name)"' 0 "python3: os模块"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All python 命令行选项 tests passed!"

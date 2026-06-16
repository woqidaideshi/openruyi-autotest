#!/bin/sh -eux
# Functional test: python - 脚本执行

. "../setup.sh"

echo "=== 测试 3: 脚本执行 ==="
TmpDir=$(mktemp -d); cd $TmpDir
echo 'print("hello python")' > test.py
rlRun 'python3 test.py' 0 "python3 执行脚本"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All python 脚本执行 tests passed!"

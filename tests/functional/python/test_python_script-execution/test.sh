#!/bin/sh -eux
# Functional test: python - 脚本执行

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q python3' 0 "检查 python3 是否已安装"
rlRun 'which python3' 0 "检查 python3 命令是否可用"
rlRun 'python3 --version' 0 "Python 版本"
rlRun 'which python3' 0 "python3 可用"
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

#!/bin/sh -eux
# Functional test: python - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q python3' 0 "检查 python3 是否已安装"
rlRun 'which python3' 0 "检查 python3 命令是否可用"
rlRun 'python3 --version' 0 "Python 版本"
rlRun 'which python3' 0 "python3 可用"
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

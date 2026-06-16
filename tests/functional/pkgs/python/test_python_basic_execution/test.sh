#!/bin/sh -eux
# Functional test: python - 基本执行

. "../setup.sh"

echo "=== 测试 1: 基本执行 ==="
rlRun 'python3 -c "print(1+2)"' 0 "Python 基本运算"
rlRun 'python3 -c "import sys; print(sys.version)"' 0 "Python sys模块"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All python 基本执行 tests passed!"

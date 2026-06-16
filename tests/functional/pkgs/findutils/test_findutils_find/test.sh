#!/bin/sh -eux
# Functional test: findutils - find-基本查找

. "../setup.sh"

echo "=== 测试 1: find 基本查找 ==="
mkdir -p a/b/c
touch a/f1.txt a/f2.txt a/b/f3.txt
rlRun 'find . -name "*.txt"' 0 "find -name: 按名称查找"
rlRun 'find . -type f' 0 "find -type f: 查找文件"
rlRun 'find . -type d' 0 "find -type d: 查找目录"

. "../teardown.sh"
echo "All findutils find-基本查找 tests passed!"

#!/bin/sh -eux
# Functional test: sed - 基本替换

. "../setup.sh"

echo "=== 测试 1: 基本替换 ==="
echo "hello world" > test.txt
rlRun 'sed "s/world/sed/" test.txt' 0 "sed s: 基本替换"
rlRun 'sed "s/hello/HI/" test.txt' 0 "sed s: 替换hello"

. "../teardown.sh"
echo "All sed 基本替换 tests passed!"

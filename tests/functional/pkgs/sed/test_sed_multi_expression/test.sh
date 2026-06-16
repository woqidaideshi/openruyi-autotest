#!/bin/sh -eux
# Functional test: sed - 多表达式

. "../setup.sh"

echo "=== 测试 5: 多表达式 ==="
rlRun 'echo "abc" | sed -e "s/a/A/" -e "s/c/C/"' 0 "sed -e: 多表达式"

. "../teardown.sh"
echo "All sed 多表达式 tests passed!"

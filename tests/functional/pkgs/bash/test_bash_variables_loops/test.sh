#!/bin/sh -eux
# Functional test: bash - 变量和循环

. "../setup.sh"

echo "=== 测试 2: 变量和循环 ==="
rlRun 'bash -c "for i in 1 2 3; do echo \$i; done"' 0 "bash -c: for循环"

. "../teardown.sh"
echo "All bash 变量和循环 tests passed!"

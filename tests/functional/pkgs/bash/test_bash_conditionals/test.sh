#!/bin/sh -eux
# Functional test: bash - 条件判断

. "../setup.sh"

echo "=== 测试 3: 条件判断 ==="
rlRun 'bash -c "if [ 1 -eq 1 ]; then echo ok; fi"' 0 "bash: if条件"

. "../teardown.sh"
echo "All bash 条件判断 tests passed!"

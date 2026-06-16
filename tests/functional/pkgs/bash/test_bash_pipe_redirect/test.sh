#!/bin/sh -eux
# Functional test: bash - 管道和重定向

. "../setup.sh"

echo "=== 测试 5: 管道和重定向 ==="
rlRun 'bash -c "echo test | cat"' 0 "bash: 管道"

. "../teardown.sh"
echo "All bash 管道和重定向 tests passed!"

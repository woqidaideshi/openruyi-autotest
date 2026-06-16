#!/bin/sh -eux
# Functional test: bash - 基本脚本执行

. "../setup.sh"

echo "=== 测试 1: 基本脚本执行 ==="
echo 'echo "hello bash"' > test.sh
rlRun 'bash test.sh' 0 "bash 执行脚本"

. "../teardown.sh"
echo "All bash 基本脚本执行 tests passed!"

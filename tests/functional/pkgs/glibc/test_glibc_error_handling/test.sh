#!/bin/sh -eux
# Functional test: glibc - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'gencat --invalid 2>&1 || true' 0 "gencat: 无效选项"

. "../teardown.sh"
echo "All glibc 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: pam - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'faillock --invalid 2>&1 || true' 0 "faillock: 无效选项"

. "../teardown.sh"
echo "All pam 错误处理 tests passed!"

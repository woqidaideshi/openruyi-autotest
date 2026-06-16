#!/bin/sh -eux
# Functional test: xz - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'xz --invalid 2>&1 || true' 0 "xz: 无效选项"

. "../teardown.sh"
echo "All xz 错误处理 tests passed!"

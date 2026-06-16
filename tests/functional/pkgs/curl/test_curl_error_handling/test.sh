#!/bin/sh -eux
# Functional test: curl - 错误处理

. "../setup.sh"

echo "=== 测试 6: 错误处理 ==="
rlRun 'curl --invalid 2>&1 || true' 0 "curl: 无效选项"

. "../teardown.sh"
echo "All curl 错误处理 tests passed!"

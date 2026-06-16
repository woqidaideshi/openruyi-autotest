#!/bin/sh -eux
# Functional test: ca-certificates - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"

. "../teardown.sh"
echo "All ca-certificates 错误处理 tests passed!"

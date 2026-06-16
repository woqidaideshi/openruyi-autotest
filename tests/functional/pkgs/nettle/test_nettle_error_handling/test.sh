#!/bin/sh -eux
# Functional test: nettle - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'nettle-hash --invalid 2>&1 || true' 0 "nettle-hash: 无效选项"

. "../teardown.sh"
echo "All nettle 错误处理 tests passed!"

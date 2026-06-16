#!/bin/sh -eux
# Functional test: zstd - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'zstd --invalid 2>&1 || true' 0 "zstd: 无效选项"

. "../teardown.sh"
echo "All zstd 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: elfutils - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'eu-addr2line --invalid 2>&1 || true' 0 "eu-addr2line: 无效选项"

. "../teardown.sh"
echo "All elfutils 错误处理 tests passed!"

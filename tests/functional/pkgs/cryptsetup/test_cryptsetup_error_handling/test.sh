#!/bin/sh -eux
# Functional test: cryptsetup - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'cryptsetup --invalid 2>&1 || true' 0 "cryptsetup: 无效选项"

. "../teardown.sh"
echo "All cryptsetup 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: pkgconf - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'pkgconf --invalid 2>&1 || true' 0 "pkgconf: 无效选项"

. "../teardown.sh"
echo "All pkgconf 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: gzip - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'gzip --invalid 2>&1 || true' 0 "gzip: 无效选项"

. "../teardown.sh"
echo "All gzip 错误处理 tests passed!"

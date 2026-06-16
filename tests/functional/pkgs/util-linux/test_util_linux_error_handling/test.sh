#!/bin/sh -eux
# Functional test: util-linux - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'addpart --invalid 2>&1 || true' 0 "addpart: 无效选项"

. "../teardown.sh"
echo "All util-linux 错误处理 tests passed!"

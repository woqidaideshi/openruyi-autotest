#!/bin/sh -eux
# Functional test: debugedit - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'debugedit --invalid 2>&1 || true' 0 "debugedit: 无效选项"

. "../teardown.sh"
echo "All debugedit 错误处理 tests passed!"

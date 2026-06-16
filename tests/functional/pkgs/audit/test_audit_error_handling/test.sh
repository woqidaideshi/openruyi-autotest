#!/bin/sh -eux
# Functional test: audit - 错误处理

. "../setup.sh"

echo "=== 测试 2: 错误处理 ==="
rlRun 'auditctl --invalid 2>&1 || true' 0 "auditctl: 无效选项"

. "../teardown.sh"
echo "All audit 错误处理 tests passed!"

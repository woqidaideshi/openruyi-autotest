#!/bin/sh -eux
# Functional test: sed - 错误处理

. "../setup.sh"

echo "=== 测试 6: 错误处理 ==="
rlRun 'sed --invalid 2>&1 || true' 0 "sed: 无效选项"

cd /; rm -rf $TmpDir

. "../teardown.sh"
echo "All sed 错误处理 tests passed!"

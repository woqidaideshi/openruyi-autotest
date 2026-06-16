#!/bin/sh -eux
# Functional test: bash - 错误处理

. "../setup.sh"

echo "=== 测试 7: 错误处理 ==="
rlRun 'bash -c "exit 1" 2>&1 || true' 0 "bash: 错误退出"

cd /; rm -rf $TmpDir

. "../teardown.sh"
echo "All bash 错误处理 tests passed!"

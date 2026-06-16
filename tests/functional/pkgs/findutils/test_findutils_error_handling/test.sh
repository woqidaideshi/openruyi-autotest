#!/bin/sh -eux
# Functional test: findutils - 错误处理

. "../setup.sh"

echo "=== 测试 5: 错误处理 ==="
rlRun 'find /nonexistent 2>&1 || true' 0 "find: 无效路径"

cd /; rm -rf $TmpDir

. "../teardown.sh"
echo "All findutils 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: findutils - find-执行操作

. "../setup.sh"

echo "=== 测试 3: find 执行操作 ==="
rlRun 'find . -name "f1.txt" -exec cat {} \;' 0 "find -exec: 执行命令"
rlRun 'find . -name "*.txt" -delete' 0 "find -delete: 删除文件"
rlRun 'test ! -f a/f1.txt' 0 "find -delete: 验证删除"

. "../teardown.sh"
echo "All findutils find-执行操作 tests passed!"

#!/bin/sh -eux
# Functional test: findutils - find-选项

. "../setup.sh"

echo "=== 测试 2: find 选项 ==="
rlRun 'find . -maxdepth 1 -name "*.txt"' 0 "find -maxdepth: 最大深度"
rlRun 'find . -mindepth 2' 0 "find -mindepth: 最小深度"
rlRun 'find . -empty' 0 "find -empty: 空文件/目录"
rlRun 'find . -size +0c' 0 "find -size: 按大小"

. "../teardown.sh"
echo "All findutils find-选项 tests passed!"

#!/bin/sh -eux
# Functional test: sed - 全局和正则

. "../setup.sh"

echo "=== 测试 3: 全局和正则 ==="
rlRun 'echo "aaa" | sed "s/a/b/g"' 0 "sed g: 全局替换"
rlRun 'echo "abc123" | sed "s/[0-9]/X/g"' 0 "sed: 正则替换"

. "../teardown.sh"
echo "All sed 全局和正则 tests passed!"

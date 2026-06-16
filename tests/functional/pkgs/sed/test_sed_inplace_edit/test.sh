#!/bin/sh -eux
# Functional test: sed - 就地编辑

. "../setup.sh"

echo "=== 测试 4: 就地编辑 ==="
echo "original" > edit.txt
rlRun 'sed -i "s/original/modified/" edit.txt' 0 "sed -i: 就地编辑"
rlRun 'grep modified edit.txt' 0 "sed -i: 验证修改"

. "../teardown.sh"
echo "All sed 就地编辑 tests passed!"

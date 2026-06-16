#!/bin/sh -eux
# Functional test: bash - 函数

. "../setup.sh"

echo "=== 测试 4: 函数 ==="
rlRun 'bash -c "f() { echo func; }; f"' 0 "bash: 函数定义调用"

. "../teardown.sh"
echo "All bash 函数 tests passed!"

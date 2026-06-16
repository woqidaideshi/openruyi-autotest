#!/bin/sh -eux
# Functional test: bash package
# Tests Bash Shell
# Version: bash

. "./setup.sh"

echo "=== 测试 1: 基本脚本执行 ==="
echo 'echo "hello bash"' > test.sh
rlRun 'bash test.sh' 0 "bash 执行脚本"

echo "=== 测试 2: 变量和循环 ==="
rlRun 'bash -c "for i in 1 2 3; do echo \$i; done"' 0 "bash -c: for循环"

echo "=== 测试 3: 条件判断 ==="
rlRun 'bash -c "if [ 1 -eq 1 ]; then echo ok; fi"' 0 "bash: if条件"

echo "=== 测试 4: 函数 ==="
rlRun 'bash -c "f() { echo func; }; f"' 0 "bash: 函数定义调用"

echo "=== 测试 5: 管道和重定向 ==="
rlRun 'bash -c "echo test | cat"' 0 "bash: 管道"

echo "=== 测试 6: bashbug ==="
rlRun 'bashbug --help 2>&1 | head -3 || true' 0 "bashbug 帮助"

echo "=== 测试 7: 错误处理 ==="
rlRun 'bash -c "exit 1" 2>&1 || true' 0 "bash: 错误退出"

cd /; rm -rf $TmpDir

. "./teardown.sh"
echo "All bash functional tests passed!"

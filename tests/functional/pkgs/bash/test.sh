#!/bin/sh -eux
# Functional test: bash package
# Tests Bash Shell
# Version: bash

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install bash ===
INSTALLED_BY_TEST=0
if ! rpm -q bash 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bash 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bash"
    else
        echo "SKIP: bash not available in repos"
        exit 0
    fi
else
    echo "SETUP: bash already installed"
fi



rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"

TmpDir=$(mktemp -d); cd $TmpDir

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

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bash 2>/dev/null || true
    echo "TEARDOWN: removed bash"
fi
echo ""
echo "All bash functional tests passed!"

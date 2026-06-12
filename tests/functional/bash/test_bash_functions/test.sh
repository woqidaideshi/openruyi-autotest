#!/bin/sh -eux
# Functional test: bash - 函数

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q bash 2>/dev/null || { echo 'bash not installed, skipping'; exit 0; }
which bash 2>/dev/null || echo 'bash not found'
which sh 2>/dev/null || echo 'sh not found'
which bashbug 2>/dev/null || echo 'bashbug not found'
rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 4: 函数 ==="
rlRun 'bash -c "f() { echo func; }; f"' 0 "bash: 函数定义调用"


echo ""
echo "All bash 函数 tests passed!"

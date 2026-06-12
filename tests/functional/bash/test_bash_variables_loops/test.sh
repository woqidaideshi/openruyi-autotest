#!/bin/sh -eux
# Functional test: bash - 变量和循环

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q bash 2>/dev/null || { echo 'bash not installed, skipping'; exit 0; }
which bash 2>/dev/null || echo 'bash not found'
which sh 2>/dev/null || echo 'sh not found'
which bashbug 2>/dev/null || echo 'bashbug not found'
rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 2: 变量和循环 ==="
rlRun 'bash -c "for i in 1 2 3; do echo \$i; done"' 0 "bash -c: for循环"


echo ""
echo "All bash 变量和循环 tests passed!"

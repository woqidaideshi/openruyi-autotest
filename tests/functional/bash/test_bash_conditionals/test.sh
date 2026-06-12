#!/bin/sh -eux
# Functional test: bash - 条件判断

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q bash 2>/dev/null || { echo 'bash not installed, skipping'; exit 0; }
which bash 2>/dev/null || echo 'bash not found'
which sh 2>/dev/null || echo 'sh not found'
which bashbug 2>/dev/null || echo 'bashbug not found'
rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 3: 条件判断 ==="
rlRun 'bash -c "if [ 1 -eq 1 ]; then echo ok; fi"' 0 "bash: if条件"


echo ""
echo "All bash 条件判断 tests passed!"

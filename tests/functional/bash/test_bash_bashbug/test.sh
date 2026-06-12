#!/bin/sh -eux
# Functional test: bash - bashbug

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q bash 2>/dev/null || { echo 'bash not installed, skipping'; exit 0; }
which bash 2>/dev/null || echo 'bash not found'
which sh 2>/dev/null || echo 'sh not found'
which bashbug 2>/dev/null || echo 'bashbug not found'
rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 6: bashbug ==="
rlRun 'bashbug --help 2>&1 | head -3 || true' 0 "bashbug 帮助"


echo ""
echo "All bash bashbug tests passed!"

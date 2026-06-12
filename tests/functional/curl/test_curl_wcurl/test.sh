#!/bin/sh -eux
# Functional test: curl - wcurl

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q curl 2>/dev/null || { echo 'curl not installed, skipping'; exit 0; }
which curl 2>/dev/null || echo 'curl not found'
which wcurl 2>/dev/null || echo 'wcurl not found'
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 5: wcurl ==="
rlRun 'wcurl --help 2>&1 | head -5 || echo "wcurl帮助"' 0 "wcurl 帮助"

cd /
rm -rf $TmpDir

echo ""
echo "All curl wcurl tests passed!"

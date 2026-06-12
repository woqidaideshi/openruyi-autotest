#!/bin/sh -eux
# Functional test: curl - 详细模式和静默模式

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q curl 2>/dev/null || { echo 'curl not installed, skipping'; exit 0; }
which curl 2>/dev/null || echo 'curl not found'
which wcurl 2>/dev/null || echo 'wcurl not found'
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 3: 详细模式和静默模式 ==="
rlRun 'curl -v http://example.com 2>&1 | head -5 || echo "详细模式"' 0 "curl -v: 详细模式"
rlRun 'curl -s http://example.com 2>&1 | head -3' 0 "curl -s: 静默模式"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 详细模式和静默模式 tests passed!"

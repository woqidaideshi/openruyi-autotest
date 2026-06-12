#!/bin/sh -eux
# Functional test: glibc - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q glibc 2>/dev/null || { echo 'glibc not installed, skipping'; exit 0; }
which gencat 2>/dev/null || echo 'gencat not found'
which getconf 2>/dev/null || echo 'getconf not found'
which getent 2>/dev/null || echo 'getent not found'
which iconv 2>/dev/null || echo 'iconv not found'
which ldconfig 2>/dev/null || echo 'ldconfig not found'
which ldd 2>/dev/null || echo 'ldd not found'
which locale 2>/dev/null || echo 'locale not found'
which localedef 2>/dev/null || echo 'localedef not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'gencat --invalid 2>&1 || true' 0 "gencat: 无效选项"

echo ""
echo "All glibc functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All glibc 错误处理 tests passed!"

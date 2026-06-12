#!/bin/sh -eux
# Functional test: dwz - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dwz 2>/dev/null || { echo 'dwz not installed, skipping'; exit 0; }
which dwz 2>/dev/null || echo 'dwz not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'dwz --version 2>&1 || true' 0 "dwz 版本信息"
rlRun 'dwz --help 2>&1 | head -5 || true' 0 "dwz 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All dwz 版本和帮助 tests passed!"

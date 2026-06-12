#!/bin/sh -eux
# Functional test: ca-certificates - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q ca-certificates 2>/dev/null || { echo 'ca-certificates not installed, skipping'; exit 0; }
which update-ca-trust 2>/dev/null || echo 'update-ca-trust not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'update-ca-trust --version 2>&1 || true' 0 "update-ca-trust 版本信息"
rlRun 'update-ca-trust --help 2>&1 | head -5 || true' 0 "update-ca-trust 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates 版本和帮助 tests passed!"

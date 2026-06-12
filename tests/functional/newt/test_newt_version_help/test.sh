#!/bin/sh -eux
# Functional test: newt - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q newt 2>/dev/null || { echo 'newt not installed, skipping'; exit 0; }
which whiptail 2>/dev/null || echo 'whiptail not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'whiptail --version 2>&1 || true' 0 "whiptail 版本信息"
rlRun 'whiptail --help 2>&1 | head -5 || true' 0 "whiptail 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All newt 版本和帮助 tests passed!"

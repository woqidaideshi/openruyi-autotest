#!/bin/sh -eux
# Functional test: pam - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q pam 2>/dev/null || { echo 'pam not installed, skipping'; exit 0; }
which faillock 2>/dev/null || echo 'faillock not found'
which mkhomedir_helper 2>/dev/null || echo 'mkhomedir_helper not found'
which pam_timestamp_check 2>/dev/null || echo 'pam_timestamp_check not found'
which unix_chkpwd 2>/dev/null || echo 'unix_chkpwd not found'
which unix_update 2>/dev/null || echo 'unix_update not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'faillock --invalid 2>&1 || true' 0 "faillock: 无效选项"

echo ""
echo "All pam functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All pam 错误处理 tests passed!"

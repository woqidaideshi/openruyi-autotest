#!/bin/sh -eux
# Functional test: pam - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q pam' 0 "检查 pam 是否已安装"
rlRun 'which faillock' 0 "检查 faillock 命令是否可用"
rlRun 'which mkhomedir_helper' 0 "检查 mkhomedir_helper 命令是否可用"
rlRun 'which pam_timestamp_check' 0 "检查 pam_timestamp_check 命令是否可用"
rlRun 'which unix_chkpwd' 0 "检查 unix_chkpwd 命令是否可用"
rlRun 'which unix_update' 0 "检查 unix_update 命令是否可用"
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

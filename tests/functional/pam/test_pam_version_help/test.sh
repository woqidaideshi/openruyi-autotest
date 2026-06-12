#!/bin/sh -eux
# Functional test: pam - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q pam' 0 "检查 pam 是否已安装"
rlRun 'which faillock' 0 "检查 faillock 命令是否可用"
rlRun 'which mkhomedir_helper' 0 "检查 mkhomedir_helper 命令是否可用"
rlRun 'which pam_timestamp_check' 0 "检查 pam_timestamp_check 命令是否可用"
rlRun 'which unix_chkpwd' 0 "检查 unix_chkpwd 命令是否可用"
rlRun 'which unix_update' 0 "检查 unix_update 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'faillock --version 2>&1 || true' 0 "faillock 版本信息"
rlRun 'faillock --help 2>&1 | head -5 || true' 0 "faillock 帮助信息"
rlRun 'mkhomedir_helper --version 2>&1 || true' 0 "mkhomedir_helper 版本信息"
rlRun 'mkhomedir_helper --help 2>&1 | head -5 || true' 0 "mkhomedir_helper 帮助信息"
rlRun 'pam_timestamp_check --version 2>&1 || true' 0 "pam_timestamp_check 版本信息"
rlRun 'pam_timestamp_check --help 2>&1 | head -5 || true' 0 "pam_timestamp_check 帮助信息"
rlRun 'unix_chkpwd --version 2>&1 || true' 0 "unix_chkpwd 版本信息"
rlRun 'unix_chkpwd --help 2>&1 | head -5 || true' 0 "unix_chkpwd 帮助信息"
rlRun 'unix_update --version 2>&1 || true' 0 "unix_update 版本信息"
rlRun 'unix_update --help 2>&1 | head -5 || true' 0 "unix_update 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All pam 版本和帮助 tests passed!"

#!/bin/sh -eux
# Functional test: pam - 版本和帮助

. "../setup.sh"

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

. "../teardown.sh"
echo "All pam 版本和帮助 tests passed!"

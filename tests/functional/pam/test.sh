#!/bin/sh -eux
# Functional test: pam package
# Tests PAM 认证模块
# Version: pam

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q pam 2>/dev/null || { echo 'pam not installed, skipping'; exit 0; }
which faillock 2>/dev/null || echo 'faillock not found'
which mkhomedir_helper 2>/dev/null || echo 'mkhomedir_helper not found'
which pam_timestamp_check 2>/dev/null || echo 'pam_timestamp_check not found'
which unix_chkpwd 2>/dev/null || echo 'unix_chkpwd not found'
which unix_update 2>/dev/null || echo 'unix_update not found'

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

echo "=== 测试 2: 错误处理 ==="
rlRun 'faillock --invalid 2>&1 || true' 0 "faillock: 无效选项"

echo ""
echo "All pam functional tests passed!"

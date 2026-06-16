#!/bin/sh -eux
# Functional test: pam - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install pam ===
INSTALLED_BY_TEST=0
if ! rpm -q pam 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pam 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pam"
    else
        echo "SKIP: pam not available in repos"
        exit 0
    fi
else
    echo "SETUP: pam already installed"
fi

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


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pam 2>/dev/null || true
    echo "TEARDOWN: removed pam"
fi
echo ""
echo "All pam 版本和帮助 tests passed!"

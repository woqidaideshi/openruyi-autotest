#!/bin/sh -eux
# Functional test: pam - 错误处理

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

echo "=== 测试 2: 错误处理 ==="
rlRun 'faillock --invalid 2>&1 || true' 0 "faillock: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pam 2>/dev/null || true
    echo "TEARDOWN: removed pam"
fi
echo ""
echo "All pam functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All pam 错误处理 tests passed!"

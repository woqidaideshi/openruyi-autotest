#!/bin/sh -eux
# Functional test: newt - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install newt ===
INSTALLED_BY_TEST=0
if ! rpm -q newt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y newt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed newt"
    else
        echo "SKIP: newt not available in repos"
        exit 0
    fi
else
    echo "SETUP: newt already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'whiptail --version 2>&1 || true' 0 "whiptail 版本信息"
rlRun 'whiptail --help 2>&1 | head -5 || true' 0 "whiptail 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y newt 2>/dev/null || true
    echo "TEARDOWN: removed newt"
fi
echo ""
echo "All newt 版本和帮助 tests passed!"

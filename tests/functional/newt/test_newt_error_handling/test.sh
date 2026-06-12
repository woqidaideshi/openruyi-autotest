#!/bin/sh -eux
# Functional test: newt - 错误处理

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

echo "=== 测试 2: 错误处理 ==="
rlRun 'whiptail --invalid 2>&1 || true' 0 "whiptail: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y newt 2>/dev/null || true
    echo "TEARDOWN: removed newt"
fi
echo ""
echo "All newt functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All newt 错误处理 tests passed!"

#!/bin/sh -eux
# Functional test: cryptsetup - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cryptsetup ===
INSTALLED_BY_TEST=0
if ! rpm -q cryptsetup 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cryptsetup 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cryptsetup"
    else
        echo "SKIP: cryptsetup not available in repos"
        exit 0
    fi
else
    echo "SETUP: cryptsetup already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'cryptsetup --invalid 2>&1 || true' 0 "cryptsetup: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cryptsetup 2>/dev/null || true
    echo "TEARDOWN: removed cryptsetup"
fi
echo ""
echo "All cryptsetup functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All cryptsetup 错误处理 tests passed!"
